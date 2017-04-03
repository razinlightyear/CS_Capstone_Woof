class CreateLostDogs < ActiveRecord::Migration[5.0]
  def change
    create_table :lost_dogs do |t|
      t.text :description
      t.timestamps
    end
  end
end
