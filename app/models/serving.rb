class Serving < ApplicationRecord
  belongs_to :servingable, polymorphic: true
  has_many :price_records

  after_save :save_price_record

  def price_history
    self.price_records
  end

  private
  def save_price_record
    self.price_records.create(price: self.current_price, change_date: Time.zone.now)
  end
end
