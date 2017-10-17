class AddPetIdToNudges < ActiveRecord::Migration[5.0]
  def change
    add_column :nudges, :pet_id, :integer
  end
end
