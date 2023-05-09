class Item < ApplicationRecord
  belongs_to :user
  enum status: { active: 0, inactive: 1 }
end
