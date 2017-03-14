class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id, :null => false, :references => [:users, :id]

      t.timestamps
    end
  end
end
