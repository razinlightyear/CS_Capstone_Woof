class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id, :null => false

      t.timestamps
    end
    add_foreign_key :groups, :users, column: :owner_id
  end
end
