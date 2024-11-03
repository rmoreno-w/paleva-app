class Tag < ApplicationRecord
  belongs_to :restaurant
  has_many :dish_tags, dependent: :destroy
  has_many :dishes, through: :dish_tags

  validates :name, presence: true
  validates :name, uniqueness: true
end
