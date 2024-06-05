class AddSortToBanners < ActiveRecord::Migration[7.0]
  def change
    add_column :banners, :sort, :integer
  end
end
