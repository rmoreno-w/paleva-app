class Serving < ApplicationRecord
  belongs_to :servingable, polymorphic: true
end
