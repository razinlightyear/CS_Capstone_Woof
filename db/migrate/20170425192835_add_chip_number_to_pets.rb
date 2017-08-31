class AddChipNumberToPets < ActiveRecord::Migration[5.0]
  def change
    add_column :pets, :chip_number, :string
  end
end
