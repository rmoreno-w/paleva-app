class Dish < ApplicationRecord
  has_one_attached :picture
  belongs_to :restaurant
  has_many :servings, as: :servingable
  has_many :dish_tags
  has_many :tags, through: :dish_tags
  has_many :item_option_entries, as: :itemable

  validates :name, :description, presence: true

  enum :status, { inactive: 0, active: 1 }
end
