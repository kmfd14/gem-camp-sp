class ChangeColumnsToUserAddresses < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_addresses, :region_id, :integer
    remove_column :user_addresses, :province_id, :integer
    remove_column :user_addresses, :city_id, :integer
    remove_column :user_addresses, :barangay_id, :integer

    add_reference :user_addresses, :address_region
    add_reference :user_addresses, :address_province
    add_reference :user_addresses, :address_city
    add_reference :user_addresses, :address_barangay
  end
end
