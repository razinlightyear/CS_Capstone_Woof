class Event < ApplicationRecord
  belongs_to :pet_event, polymorphic: true
  belongs_to :pet, optional: true
  belongs_to :user
end
