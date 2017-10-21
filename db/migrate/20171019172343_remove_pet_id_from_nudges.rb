class RemovePetIdFromNudges < ActiveRecord::Migration[5.0]
  def change
    remove_column :nudges, :pet_id, :integer
  end
end
