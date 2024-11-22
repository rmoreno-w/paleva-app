class Serving < ApplicationRecord
  belongs_to :servingable, polymorphic: true
  has_many :price_records
  
  has_many :discounted_servings
  has_many :discounts, through: :discounted_servings

  after_save :save_price_record

  validates :description, :current_price, presence: true
  validates :current_price, numericality: { greater_than: 0 }

  def price_history
    self.price_records
  end

  def full_description
    "#{self.servingable.name} --- Porção: #{self.description}" 
  end

  def has_active_discount?
    self.discounts.where('start_date <= ? and end_date >= ? and number_of_uses < limit_of_uses', Time.now, Time.now).length > 0
  end

  def best_discount
    self.discounts.where('start_date <= ? and end_date >= ? and number_of_uses < limit_of_uses', Time.now, Time.now).order(percentage: :asc).last
  end

  private
  def save_price_record
    if !new_record? && saved_change_to_current_price?
      self.price_records.create(price: self.current_price, change_date: Time.zone.now)
    end
  end
end
