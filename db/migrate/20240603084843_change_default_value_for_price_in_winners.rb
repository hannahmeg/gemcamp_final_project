class ChangeDefaultValueForPriceInWinners < ActiveRecord::Migration[7.0]
  def change
    change_column_default :winners, :price, 0.00
    Winner.where(price: nil).update_all(price: 0.00)
  end
end
