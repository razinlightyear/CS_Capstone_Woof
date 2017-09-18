class AddActiveToPets < ActiveRecord::Migration[5.0]
  def change
    add_column :pets, :active, :boolean, null: false, default: true
  end
end
