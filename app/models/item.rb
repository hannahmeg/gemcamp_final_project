class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  def destroy
    update(deleted_at: Time.current)
  end
end
