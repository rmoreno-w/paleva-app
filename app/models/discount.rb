class Discount < ApplicationRecord
  belongs_to :restaurant

  validates :name, :percentage, :start_date, :end_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }
end
