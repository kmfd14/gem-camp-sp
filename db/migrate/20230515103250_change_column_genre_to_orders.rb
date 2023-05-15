class ChangeColumnGenreToOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_default :orders, :genre, 0
  end
end
