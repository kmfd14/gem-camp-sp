class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :image
      t.string :name
      t.string :status
      t.decimal :amount, default: 0, precision: 18, scale: 2
      t.integer :coin
      t.timestamps
    end
  end
end
