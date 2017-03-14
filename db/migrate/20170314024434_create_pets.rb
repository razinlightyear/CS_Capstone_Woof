class CreatePets < ActiveRecord::Migration[5.0]
  def change
    create_table :pets do |t|
      t.string :name
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
