class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :offer
      t.string :serial_number
      t.string :state
      t.decimal :amount, default: 0, precision: 18, scale: 2
      t.integer :coin
      t.string :remarks
      t.integer :genre
      t.timestamps
    end
  end
end
