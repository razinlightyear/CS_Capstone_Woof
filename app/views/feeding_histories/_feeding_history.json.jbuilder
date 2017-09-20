json.extract! feeding_history, :id, :amount, :food_item, :created_at
json.pet feeding_history.pet, partial: "pets/pet", as: :pet
