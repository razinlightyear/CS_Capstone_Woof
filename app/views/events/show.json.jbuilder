#json.user @user, partial: "users/user", as: :user
#json.pets @pets, partial: "pets/pet", as: :pet
#json.around_me_events @around_me_events, partial: "events/around_me", as: :around_me_event

#json.events @events

json.events do
   
   json.array! @events.where(:is_around_me => 1) do |event|
       if event.pet_id.nil?
           json.event_id event.id
           json.event_type event.type
           json.latitude event.latitude
           json.longitude event.longitude
           json.description event.description
           json.user_id event.user.id
           json.first_name event.user.first_name
           json.last_name event.user.last_name
       else
           json.event_id event.id
           json.event_type event.type
           json.latitude event.latitude
           json.longitude event.longitude
           json.description event.description
           json.user_id event.user.id
           json.first_name event.user.first_name
           json.last_name event.user.last_name
           json.pet_id event.pet_id
           json.pet_name event.pet.name
           json.pet_group event.pet.group_id
       end
   end
end