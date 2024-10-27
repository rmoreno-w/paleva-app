class Dish < ApplicationRecord
  has_one_attached :picture
  belongs_to :restaurant

  validates :name, :description, presence: true
end
