class RemoveBreedConstraintFromFoundDog < ActiveRecord::Migration[5.0]
  change_column_null(:found_dog_delegates, :breed_id, true)
end
