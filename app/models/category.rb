class Category < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :name, presence: true

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :items, through: :item_category_ships

  def destroy
    unless items.exists?
      update(deleted_at: Time.current)
    else
      errors.add(:base, 'Cannot delete category with associated items')
      throw(:abort)
    end
  end
end
