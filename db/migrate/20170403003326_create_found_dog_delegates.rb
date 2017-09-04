class CreateFoundDogDelegates < ActiveRecord::Migration[5.0]
  def change
    create_table :found_dog_delegates do |t|
      t.references :found_dog #, foreign_key: true, null: false # does not exist at the database level
      t.references :breed, foreign_key: true, null: false
      t.references :weight, foreign_key: true, null: false
      t.text :description
    end
  end
end
