class Order < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :offer, optional: true

  validates :genre, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }, if: :deposit?
  validates :coin, presence: true, numericality: { greater_than: 0 }, if: :deposit?
  validates :remarks, presence: true, if: :is_not_deposit?

  after_create :generate_serial_number

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4, member_level: 5 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: :paid, to: :cancelled,
                  guard: [:enough_balance?, :is_not_deduct?],
                  success: [:decrease_coin_unless_deduct, :decrease_total_deposit]
      transitions from: :paid, to: :cancelled,
                  guard: :deduct?,
                  success: :increase_coin_if_deduct
      transitions from: :submitted, to: :cancelled
    end

    event :pay do
      transitions from: :submitted, to: :paid,
                  success: [:adjust_coins, :increase_total_deposit]
      transitions from: :pending, to: :paid,
                  guard: :is_not_deposit?,
                  success: :adjust_coins
    end
  end

  private

  def generate_serial_number
    count = Order.where(user: user).count

    number_count = (count + 1).to_s.rjust(4, '0')

    formatted_time = Time.current.strftime("%y%m%d")

    self.update(serial_number: "#{formatted_time}-#{self.id}-#{user.id}-#{number_count}")
  end

  def adjust_coins
    if deduct?
      user.update(coins: user.coins - coin)
    else
      user.update(coins: user.coins + coin)
    end
  end

  def increase_total_deposit
    user.update(total_deposit: user.total_deposit + amount) if deposit?
  end

  def decrease_total_deposit
    user.update(total_deposit: user.total_deposit - amount) if deposit?
  end

  def enough_balance?
    user.coins > coin
  end

  def decrease_coin_unless_deduct
    user.update(coins: user.coins - coin)
  end

  def increase_coin_if_deduct
    user.update(coins: user.coins + coin)
  end

  def is_not_deduct?
    genre != 'deduct'
  end

  def is_not_deposit?
    genre != 'deposit'
  end
end

