class UserAddress < ApplicationRecord
  belongs_to :user
  validate :user_address_limit, on: :create
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_city_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'

  before_save :set_default_address

  enum genre: { home: 0, office: 1 }

  private

  def user_address_limit
    if user.user_address.count >= 5
      errors.add(:base, "Exceeded Address Creation Limit")
    end
  end

  def set_default_address
    UserAddress.where(user_id: (self.user_id)).update_all(is_default: false)
  end
end
