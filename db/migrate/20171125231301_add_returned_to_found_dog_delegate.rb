class AddReturnedToFoundDogDelegate < ActiveRecord::Migration[5.0]
  def change
    add_column :found_dog_delegates, :returned, :boolean, default: false, null: false
  end
end
