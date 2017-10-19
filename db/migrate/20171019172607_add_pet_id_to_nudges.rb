class AddPetIdToNudges < ActiveRecord::Migration[5.0]
  def change
    add_reference :nudges, :pet, foreign_key: true
  end
end
