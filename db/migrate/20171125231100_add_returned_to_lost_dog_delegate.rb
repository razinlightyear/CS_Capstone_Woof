class AddReturnedToLostDogDelegate < ActiveRecord::Migration[5.0]
  def change
    add_column :lost_dog_delegates, :returned, :boolean, default: false, null: false
  end
end
