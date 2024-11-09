class OrderItem < ApplicationRecord
  belongs_to :order

  validates :item_name, :serving_description, :serving_price, :number_of_servings, presence: true
  validates :serving_price, :number_of_servings, numericality: { greater_than: 0 }
  validates :number_of_servings, numericality: { only_integer: true }

  def subtotal
    self.serving_price * self.number_of_servings
  end
end
