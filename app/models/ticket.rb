class Ticket < ApplicationRecord
  include AASM

  belongs_to :item
  belongs_to :user, counter_cache: true

  before_validation :set_batch_count
  validate :user_has_enough_coins
  after_create :deduct_coin
  before_create :generate_serial_number

  aasm column: :state do
    state :pending, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled,
                  success: :refund_coin
    end
  end

  private

  def refund_coin
    user.update(coins: user.coins + 1)
  end

  def deduct_coin
    user.update(coins: user.coins - 1)
  end


  def set_batch_count
    self.batch_count ||= item.batch_count
  end

  def generate_serial_number
    count = Ticket.where(item: item, batch_count: batch_count).count

    number_count = (count + 1).to_s.rjust(4, '0')

    formatted_time = Time.current.strftime("%y%m%d")

    self.serial_number = "#{formatted_time}-#{item.id}-#{item.batch_count}-#{number_count}"
  end

  def user_has_enough_coins
    errors.add(:base, "Not enough coins") if user.coins < 1
  end
end




