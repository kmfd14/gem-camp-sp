class ChangeColumnToUserAddresses < ActiveRecord::Migration[7.0]

  def change
    add_reference :user_addresses, :user
  end
end
