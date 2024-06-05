class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader
  enum status: { active: 0, inactive: 1 }
  enum genre: { regular: 0, daily: 1, weekly: 2, monthly: 3, one_time: 4 }
end
