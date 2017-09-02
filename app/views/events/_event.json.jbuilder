json.event_id                   event.id
json.event_time                 event.created_at
json.around_me_event_type       event.type
json.longitude                  event.longitude
json.latitude                   event.latitude
json.description                event.description
json.type                       event.type
json.user around_me_event.user, partial: "users/user", as: :user
# Remember pet might be null
if event.pet
  json.pets around_me_event.pet, partial: "pets/pet", as: :pet
else # No pet. must be a found dog
  json.found_dog event.pet, partial: "found_dogs/found_dog", as: :found_dog
end