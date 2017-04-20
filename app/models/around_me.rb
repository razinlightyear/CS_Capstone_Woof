class AroundMe < ApplicationRecord
  has_one :event, as: :pet_event, dependent: :destroy # which means if we destroy this aroundme object, we are also going to destroy the event object because one event pertains to one around_me feature.
  delegate to: :event, prefix: true # delegate the methods to event, prefix -> prefixes the called method with the parent method name: event-> if lost_dog calls update, it would be prefixed as event_update and event_update would called from event
  belongs_to :around_me_event, polymorphic: true
end