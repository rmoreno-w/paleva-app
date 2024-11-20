class OrderStatusChange < ApplicationRecord
  belongs_to :order
  has_one :order_status_change_annotation

  validates :status, :change_time, presence: true
end
