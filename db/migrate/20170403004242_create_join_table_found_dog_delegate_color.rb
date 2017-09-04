class CreateJoinTableFoundDogDelegateColor < ActiveRecord::Migration[5.0]
  def change
    create_join_table :found_dog_delegates, :colors do |t|
      t.references :found_dog_delegate, foreign_key: true
      t.references :color, foreign_key: true
    end
  end
end
