json.user @user, partial: "users/user", as: :user
json.pets @pets, partial: "pets/pet", as: :pet
json.around_me_events @around_me_events, partial: "around_me/around_me", as: :around_me_event