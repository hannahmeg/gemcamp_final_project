class NewsTicker < ApplicationRecord
  belongs_to :user

  enum status: { active: 0, inactive: 1 }

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end
