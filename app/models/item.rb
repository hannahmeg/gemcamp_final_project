class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  include AASM

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  def destroy
    update(deleted_at: Time.current)
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
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  private

  def starting_conditions_met?
    quantity.present? && quantity > 0
    # &&
    #   (offline_at && Time.current < offline_at) &&
    #   status == "active"
  end

  def update_counts
    self.quantity -= 1
    self.batch_count += 1
    save
  end
end

