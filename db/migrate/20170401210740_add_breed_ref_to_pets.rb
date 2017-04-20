class AddBreedRefToPets < ActiveRecord::Migration[5.0]
  def change
    add_reference :pets, :breed, foreign_key: true, null: false
  end
end
