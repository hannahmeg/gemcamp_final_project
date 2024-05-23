class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.references :item, foreign_key: true
      t.references :ticket, foreign_key: true
      t.references :user, foreign_key: true
      t.references :address, foreign_key: true
      t.integer :item_batch_count
      t.string :state
      t.float :price, scale: 2
      t.datetime :paid_at
      t.integer :admin_id
      t.string :picture
      t.string :comment

      t.timestamps
    end
  end
end
