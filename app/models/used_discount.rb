class UsedDiscount < ApplicationRecord
  belongs_to :order_item
  belongs_to :discount

  after_create :increase_discount_number_of_uses_count

  private
  def increase_discount_number_of_uses_count
    self.discount.increment!(:number_of_uses)
  end
end
