class Address::Province < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :region
  has_many :cities
  has_many :users, class_name: 'User', foreign_key: 'address_province_id'
end
