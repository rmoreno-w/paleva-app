class Beverage < ApplicationRecord
  belongs_to :restaurant
  has_one_attached :picture
  has_many :servings, as: :servingable
  has_many :item_option_entries, as: :itemable

  enum :status, { inactive: 0, active: 1 }

  validates :is_alcoholic, inclusion: { in: [true, false] }
  attribute :is_alcoholic, :boolean, default: false

  validates :name, :description, :calories, presence: true
end
