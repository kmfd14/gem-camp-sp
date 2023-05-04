class Address::Region < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  has_many :provinces
  has_many :user_address, class_name: 'UserAddress', foreign_key: 'address_region_id'
end
