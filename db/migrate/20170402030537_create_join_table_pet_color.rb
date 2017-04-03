class CreateJoinTablePetColor < ActiveRecord::Migration[5.0]
  def change
    create_join_table :pets, :colors do |t|
      t.references :pet, foreign_key: true
      t.references :color, foreign_key: true
    end
  end
end
