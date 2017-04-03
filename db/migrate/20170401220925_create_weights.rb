class CreateWeights < ActiveRecord::Migration[5.0]
  def change
    create_table :weights do |t|
      t.integer :start_weight
      t.integer :end_weight

      t.timestamps
    end
  end
end
