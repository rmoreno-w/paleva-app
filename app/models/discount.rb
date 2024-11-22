class Discount < ApplicationRecord
  belongs_to :restaurant

  has_many :discounted_servings
  has_many :used_discounts
  has_many :order_items, through: :used_discounts
  has_many :orders, through: :order_items

  validates :name, :percentage, :start_date, :end_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }
end
