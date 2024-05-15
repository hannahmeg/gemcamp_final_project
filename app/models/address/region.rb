class Address::Region < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  has_many :provinces
  has_many :users, class_name: 'User', foreign_key: 'address_region_id'
end
