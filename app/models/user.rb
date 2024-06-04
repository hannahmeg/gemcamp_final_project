class User < ApplicationRecord
  mount_uploader :image, ImageUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :valid_phone_number

  attr_accessor :current_password

  enum role: { client: 0, admin: 1 }

  has_many :addresses
  belongs_to :parent, class_name: 'User', optional: true
  belongs_to :member_level, optional: true
  has_many :children, class_name: 'User', foreign_key: 'parent_id', dependent: :nullify, counter_cache: :children_members_count
  has_many :tickets
  has_many :orders

  private

  def valid_phone_number
    unless Phonelib.valid_for_country?(phone_number, 'PH')
      errors.add(:phone_number, "Phone number should be valid.")
    end
  end
end
