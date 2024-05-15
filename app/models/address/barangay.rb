class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city
  has_many :users, class_name: 'User', foreign_key: 'address_barangay_id'
end
