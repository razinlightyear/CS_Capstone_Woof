class Feeding < ApplicationRecord
  has_one :event, as: :pet_event, dependent: :destroy
end
