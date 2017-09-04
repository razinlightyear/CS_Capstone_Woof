class CreateLostDogDelegates < ActiveRecord::Migration[5.0]
  def change
    create_table :lost_dog_delegates do |t|
      t.text :description
      t.references :lost_dog #, foreign_key: true, null: false # does not exist at the database level
    end
  end
end
