class ItemOptionSet < ApplicationRecord
  belongs_to :restaurant
  has_many :item_option_entries

  has_many :dishes, through: :item_option_entries, source: :itemable, source_type: 'Dish'
  has_many :beverages, through: :item_option_entries, source: :itemable, source_type: 'Beverage'

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id, message: "deve ser único para o restaurante"  }
end
