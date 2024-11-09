class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_items

  enum :status, { waiting_kitchen_approval: 1, preparing: 3, canceled: 5, ready: 7, delivered: 9 }

  before_validation :ensure_order_has_code, on: :create

  def total
    order_item_prices = self.order_items.map { |order_item| order_item.serving_price * order_item.number_of_servings }
    order_item_prices.sum
  end

  def item_count
    self.order_items.count
  end

  private
  def ensure_order_has_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end
end
