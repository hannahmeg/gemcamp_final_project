class ChangeDefaultBatchCountInItems < ActiveRecord::Migration[7.0]
  def change
    change_column_default :items, :batch_count, 0
  end
end
