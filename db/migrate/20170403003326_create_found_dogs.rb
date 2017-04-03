class CreateFoundDogs < ActiveRecord::Migration[5.0]
  def change
    create_table :found_dogs do |t|
      t.references :breed, foreign_key: true, null: false
      t.references :weight, foreign_key: true, null: false
      t.text :description
      t.timestamps
    end
  end
end
