class Order < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :offer, required: false

  validates :amount, presence: true, numericality: { greater_than: 0 }, if: :deposit?
  validates :coin, presence: true, numericality: { greater_than: 0 }, if: :deposit?

  before_create :generate_serial_number

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted, :paid], to: :cancelled,
                  guard: -> { decrease_coin_unless_deduct && balance_enough? },
                  success: [:decrease_coin_unless_deduct, :increase_coin_if_deduct, :decrease_total_deposit]
    end

    event :pay do
      transitions from: :submitted, to: :paid,
                  success: [:increase_coin_unless_deduct, :decrease_coin_if_deduct, :increase_total_deposit]
    end
  end

  private

  def generate_serial_number
    count = Order.where(user: user).count

    number_count = (count + 1).to_s.rjust(4, '0')

    formatted_time = Time.current.strftime("%y%m%d")

    self.serial_number = "#{formatted_time}-#{self.id}-#{user.id}-#{number_count}"
  end

  def increase_coin_unless_deduct
    user.update(coins: user.coins + 1) unless deduct?
  end

  def decrease_coin_if_deduct
    user.update(coins: user.coins - 1) if deduct?
  end

  def increase_total_deposit
    user.update(total_deposit: user.total_deposit + 1) if deposit?
  end

  def decrease_total_deposit
    user.update(total_deposit: user.total_deposit - 1) if deposit?
  end

  def balance_enough?
    user.coins != 0
  end

  def decrease_coin_unless_deduct
    user.update(coins: user.coins - 1) unless deduct?
  end

  def increase_coin_if_deduct
    user.update(coins: user.coins + 1) if deduct?
  end
end

