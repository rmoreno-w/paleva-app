class ItemOptionSet < ApplicationRecord
  belongs_to :restaurant
  has_many :item_option_entries

  has_many :dishes, through: :item_option_entries, source: :itemable, source_type: 'Dish'
  has_many :beverages, through: :item_option_entries, source: :itemable, source_type: 'Beverage'

  validates :end_date, presence: true, if: Proc.new { self.start_date != nil && self.start_date != '' }
  validates :start_date, presence: true, if: Proc.new { self.end_date != nil && self.end_date != '' }
  validates :end_date, comparison: { greater_than: :start_date }, if: Proc.new { self.start_date != nil && self.start_date != '' && self.end_date != nil && self.end_date != ''}

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id, message: "deve ser único para o restaurante"  }

  def active_item_option_entries
    self.item_option_entries.filter { |item_entry| item_entry.itemable.active? }
  end

  def is_seasonal?
    self.start_date.present?
  end

  def is_in_season?
    Time.zone.now > self.start_date && Time.zone.now < self.end_date
  end
end
