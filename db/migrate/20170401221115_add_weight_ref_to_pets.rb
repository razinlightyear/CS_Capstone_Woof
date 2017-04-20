class AddWeightRefToPets < ActiveRecord::Migration[5.0]
  def change
    add_reference :pets, :weight, foreign_key: true, null: false
  end
end
