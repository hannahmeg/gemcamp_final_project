class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader

  enum status: { active: 0, inactive: 1 }
end
