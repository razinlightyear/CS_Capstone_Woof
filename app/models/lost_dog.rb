class LostDog < ApplicationRecord
  has_one :around_me, as: :around_me_event, dependent: :destroy
  delegate :longitude, :latitude, to: :around_me
end