class Tag < ApplicationRecord
  belongs_to :restaurant
  has_many :dish_tags
  has_many :tags, through: :dish_tags
end
