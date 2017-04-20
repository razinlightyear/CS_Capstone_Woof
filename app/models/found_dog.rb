class FoundDog < ApplicationRecord
  has_one :around_me, as: :around_me_event, dependent: :destroy
  delegate :longitude, :latitude, to: :around_me
  has_and_belongs_to_many :colors
  belongs_to :breed
  belongs_to :weight
end


# ruby determine class 
# @paarth[3].pet_event.around_me_event.is_a?FoundDog

# most of the type, we are going to expect right away.
# you can view latitue and longitude in lostdog but you cannot set it in lost dog.
# we have forwaded the values to lost dog
#  if we want to change the values of latitude and longitude, that needs to be 
#in around_me

# when creatig the marker, you have to also ceate the form with a unique identifier. pop overs on google maps.
