class DiscountedServing < ApplicationRecord
  belongs_to :serving
  belongs_to :discount
end
