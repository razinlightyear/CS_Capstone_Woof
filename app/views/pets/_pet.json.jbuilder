json.extract! pet, :id, :name, :group_id
json.group_name    pet.group.name if pet.group
json.colors        pet.colors.pluck(:name)
json.breed         pet.breed.name
json.start_weight  pet.weight.start_weight
json.end_weight    pet.weight.end_weight