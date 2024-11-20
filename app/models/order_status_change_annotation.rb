class OrderStatusChangeAnnotation < ApplicationRecord
  belongs_to :order_status_change

  validates :annotation, presence: true
end
