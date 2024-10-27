class Beverage < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :picture

  validates :is_alcoholic, inclusion: { in: [true, false] }
  attribute :is_alcoholic, :boolean, default: false

  validates :name, :description, :calories, presence: true
end
