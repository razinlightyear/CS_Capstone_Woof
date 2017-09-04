class LostDogDelegate < ApplicationRecord
  #has_one :around_me, as: :around_me_event, dependent: :destroy
  #delegate :longitude, :latitude, to: :around_me
  belongs_to :lost_dog, inverse_of: :delegate
end
