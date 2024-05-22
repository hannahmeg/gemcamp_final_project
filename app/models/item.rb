class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  mount_uploader :image, ImageUploader
  include AASM

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :tickets

  enum status: { active: 0, inactive: 1 }

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

    event :end do
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

  def update_counts
    self.quantity -= 1
    self.batch_count += 1
    save
  end

  def cancel_tickets
    tickets.update_all(state: 'cancelled')
  end
end


