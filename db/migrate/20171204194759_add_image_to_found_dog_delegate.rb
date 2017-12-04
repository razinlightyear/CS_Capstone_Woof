class AddImageToFoundDogDelegate < ActiveRecord::Migration[5.0]
  def change
    add_column :found_dog_delegates, :image, :string
  end
end
