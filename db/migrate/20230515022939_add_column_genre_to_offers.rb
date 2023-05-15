class AddColumnGenreToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :genre, :integer
  end
end
