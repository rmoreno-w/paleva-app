class Dish < ApplicationRecord
  has_one_attached :picture
  belongs_to :restaurant
  has_many :servings, as: :servingable

  validates :name, :description, presence: true

  enum :status, { inactive: 0, active: 1 }
end
