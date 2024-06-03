class Item < ApplicationRecord
  mount_uploader :image, ImageUploader
  include AASM

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :tickets, dependent: :restrict_with_exception

  enum status: { active: 0, inactive: 1 }

  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true

  default_scope { where(deleted_at: nil) }

  def destroy
    unless tickets.exists?
      update(deleted_at: Time.current)
    else
      errors.add(:base, 'Cannot delete item with associated tickets.')
      false
    end
  end

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :paused, :ended, :cancelled], to: :starting, if: :starting_conditions_met?,
                  success: :update_counts
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, guard: :check_minimum_tickets, success: :select_winner
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, success: :cancel_tickets
    end

  end

  private

  def starting_conditions_met?
    quantity.present? && quantity > 0 && self.active? && (offline_at > Time.current)
  end

  def check_minimum_tickets
    tickets.where(batch_count: batch_count).count >= minimum_tickets
  end

  def update_counts
    self.quantity -= 1
    self.batch_count += 1
    save
  end

  def cancel_tickets
    tickets.update_all(state: 'cancelled')
  end

  def select_winner
    winning_ticket = tickets.where(batch_count: batch_count, state: 'pending').sample
    return unless winning_ticket

    Winner.create(item: self, item_batch_count: batch_count, user: winning_ticket.user, ticket: winning_ticket, state: 'won')
    tickets.where(batch_count: batch_count).update_all(state: 'lost')
    winning_ticket.update(state: 'won')
  end
end


