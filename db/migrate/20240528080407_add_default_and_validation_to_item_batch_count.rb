class AddDefaultAndValidationToItemBatchCount < ActiveRecord::Migration[7.0]
  def change
    change_column_default :items, :batch_count, 1
    change_column_null :items, :batch_count, false
  end
end
