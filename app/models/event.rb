class Event < ApplicationRecord
  belongs_to :pet_event, polymorphic: true
  belongs_to :pet, optional: true # this is an  optional column, lost dog owner might not know which dog it is.
  belongs_to :user
end
