class CreateUserAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_addresses do |t|
      t.integer :genre
      t.string :name
      t.string :street_address
      t.string :phone_number
      t.string :remark
      t.boolean :is_default
      t.integer :user_id
      t.integer :region_id
      t.integer :province_id
      t.integer :city_id
      t.integer :barangay_id
      t.timestamps
    end
  end
end
