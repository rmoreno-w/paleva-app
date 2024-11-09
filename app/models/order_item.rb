class OrderItem < ApplicationRecord
  belongs_to :order

  def subtotal
    self.serving_price * self.number_of_servings
  end
end
