class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :offer, foreign_key: true
      t.string :serial_number
      t.string :state
      t.float :amount, scale: 2
      t.integer :coin
      t.string :remarks
      t.integer :genre

      t.timestamps
    end
  end
end
