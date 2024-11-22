class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_items
  has_many :order_status_changes

  validates :customer_name, presence: true
  validates :customer_email, presence: true, if: Proc.new { self.customer_phone == nil || self.customer_phone == '' }
  validates :customer_phone, presence: true, if: Proc.new { self.customer_email == nil || self.customer_email == '' }

  validates :customer_phone, length: { minimum: 10, maximum: 11 }, if: Proc.new { self.customer_phone != nil && self.customer_phone != '' }
  validates :customer_phone, numericality: { only_integer: true }, if: Proc.new { self.customer_phone != nil && self.customer_phone != '' }

  validates :customer_email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: 'não é um formato de e-mail válido' }, if: Proc.new { self.customer_email != nil && self.customer_email != '' }
  validate :customer_registration_number_formatting, if: Proc.new { |order| order.customer_registration_number != nil && order.customer_registration_number != '' }

  enum :status, { waiting_kitchen_approval: 1, preparing: 3, canceled: 5, ready: 7, delivered: 9 }

  before_validation :ensure_order_has_code, on: :create
  # before_validation :ensure_has_at_least_one_order_item

  def total
    order_item_prices = self.order_items.map { |order_item| order_item.subtotal }
    order_item_prices.sum
  end

  def discounted_total
    order_item_prices = self.order_items.map do |order_item|
      if order_item.discounted_serving_price
        order_item.discounted_subtotal 
      else
        order_item.subtotal
      end
    end

    order_item_prices.sum
  end

  def item_count
    self.order_items.count
  end

  def is_discounted_order?
    self.order_items.any? { |order_item| order_item.discounted_serving_price }
  end

  private
  def ensure_order_has_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def customer_registration_number_formatting
    unless CPF.valid?(self.customer_registration_number)
      self.errors.add(:customer_registration_number, 'deve ser um número de CPF válido')
    end
  end

  # def ensure_has_at_least_one_order_item
  #   if self.order_items.count <= 0
  #     self.errors.add(:order_items, 'deve ter pelo menos um item de pedido associado')
  #   end
  # end
end
