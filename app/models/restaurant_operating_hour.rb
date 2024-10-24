class RestaurantOperatingHour < ApplicationRecord
  belongs_to :restaurant

  enum :weekday, { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
  enum :status, { closed: 0, opened: 1 }

  validates :start_time, :end_time, :status, :weekday, presence: true
  validates :weekday, numericality: { in: 0..6, only_integer: true }
  validates :status, numericality: { in: 0..1, only_integer: true }
  validate :is_start_time_earlier_than_end_time

  private
  def is_start_time_earlier_than_end_time
    if self.start_time && self.end_time
      self.errors.add(:start_time, 'deve ser  menor que horário do fim') if self.start_time >= self.end_time
    end
  end
end
