class PreRegistration < ApplicationRecord
  belongs_to :restaurant

  enum :status, { pending: 0, registered: 3 }, default: :pending
end
