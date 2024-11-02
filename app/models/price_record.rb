class PriceRecord < ApplicationRecord
  belongs_to :serving

  validates :change_date, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validate :validate_date

  private
  def validate_date
    self.errors.add(:change_date, 'não deve ser no passado') if self.change_date && self.change_date < Time.zone.now - 1.seconds
  end
end
