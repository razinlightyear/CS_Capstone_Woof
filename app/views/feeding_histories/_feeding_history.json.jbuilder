json.extract! feeding_history, :id, :amount, :food_item, :created_at
json.pet feeding_history.pet, partial: "pets/pet", as: :pet
json.user feeding_history.user, partial: "users/user", as: :user