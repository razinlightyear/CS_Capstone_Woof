json.event_id                   around_me_event.id
json.event_time                 around_me_event.created_at
# Remember pet might be null
json.user_id                    around_me_event.user.id
json.user_first_name            around_me_event.user.first_name
json.user_last_name             around_me_event.user.last_name
json.user_email                 around_me_event.user.email
json.around_me_event_type       around_me_event.pet_event.around_me_event_type
json.longitude                  around_me_event.pet_event.longitude
json.latitude                   around_me_event.pet_event.latitude
json.description                around_me_event.pet_event.around_me_event.description
if around_me_event.pet          
  json.pet_id                   around_me_event.pet.id
  json.pet_name                 around_me_event.pet.name
  json.pet_colors               around_me_event.pet.colors.pluck(:name)
  json.pet_breed                around_me_event.pet.breed.name
  json.pet_start_weight         around_me_event.pet.weight.start_weight
  json.pet_end_weight           around_me_event.pet.weight.end_weight
else
  json.found_dog_colors         around_me_event.pet_event.around_me_event.colors.pluck(:name)
  json.found_dog_breed          around_me_event.pet_event.around_me_event.breed.name
  json.found_dog_start_weight   around_me_event.pet_event.around_me_event.weight.start_weight
  json.found_dog_end_weight     around_me_event.pet_event.around_me_event.weight.end_weight
end