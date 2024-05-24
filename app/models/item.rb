class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  mount_uploader :image, ImageUploader
  include AASM

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :tickets

  enum status: { active: 0, inactive: 1 }

  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true

  def destroy
    unless tickets.exists?
      update(deleted_at: Time.current)
    else
      errors.add(:base, 'Cannot delete item with associated tickets')
      throw(:abort)
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

    event :end, before: :check_minimum_tickets do
      transitions from: :starting, to: :ended
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
    if tickets.where(batch_count: batch_count).count >= minimum_tickets
      select_winner
    else
      errors.add(:base, 'Not enough tickets to end the item')
      throw(:abort)
    end
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

    Winner.create(item: self, user: winning_ticket.user, ticket: winning_ticket, state: 'won')
    tickets.where(batch_count: batch_count).update_all(state: 'lost')
    winning_ticket.update(state: 'won')
  end
end


