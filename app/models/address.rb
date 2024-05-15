class Address < ApplicationRecord
  self.table_name = 'addresses'  # Specify the correct table name here

  validate :validate_address_count, on: :create

  belongs_to :user
  belongs_to :address_region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :address_province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :address_city, class_name: 'Address::City', foreign_key: 'address_city_id'
  belongs_to :address_barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'

  enum genre: { home: 0, office: 1 }

  validates :genre, presence: true
  validates :contact_person, presence: true
  validates :street_address, presence: true
  validates :phone_number, presence: true
  validates :remark, presence: true

  before_save :ensure_single_default, if: :is_default?

  private

  def ensure_single_default
    user.addresses.where.not(id: id).update_all(is_default: false)
  end

  def validate_address_count
    if user.addresses.count >= 5
      errors.add(:base, "User has reached maximum address count.")
    end
  end
end
