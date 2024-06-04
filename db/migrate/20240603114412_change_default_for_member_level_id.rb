class ChangeDefaultForMemberLevelId < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :member_level_id, from: nil, to: 1
  end
end
