class ChangeColumnToOffers < ActiveRecord::Migration[7.0]
  def change
    change_column :offers, :status, :integer, default: 0
  end
end
