class CreateJoinTableFoundDogColor < ActiveRecord::Migration[5.0]
  def change
    create_join_table :found_dogs, :colors do |t|
      t.references :found_dog, foreign_key: true
      t.references :color, foreign_key: true
    end
  end
end
