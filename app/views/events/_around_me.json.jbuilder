json.event_id                   around_me_event.id
json.event_time                 around_me_event.created_at
json.around_me_event_type       around_me_event.type
json.longitude                  around_me_event.longitude
json.latitude                   around_me_event.latitude
json.description                around_me_event.description
json.type                       around_me_event.type
json.user around_me_event.user, partial: "users/user", as: :user
# Remember pet might be null
if around_me_event.pet
  json.pets around_me_event.pet, partial: "pets/pet", as: :pet
else # No pet. must be a found dog
  json.found_dog around_me_event.pet, partial: "found_dogs/found_dog", as: :found_dog
end