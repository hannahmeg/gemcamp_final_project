class AddDefaultValuesToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :coins, from: nil, to: 0
    change_column_default :users, :total_deposit, from: nil, to: 0
    change_column_default :users, :children_members, from: nil, to: 0
  end
end
