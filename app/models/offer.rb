class Offer < ApplicationRecord
  enum status: { active: 0, inactive: 1 }
  enum genre: { one_time: 0, monthly: 1, weekly: 2, daily: 3, regular: 4}

  scope :by_status, -> (status_name) { where(offers: {status: status_name} ) }
  scope :by_genre, -> (genre_name) { where(offers: {genre: genre_name} ) }
end
