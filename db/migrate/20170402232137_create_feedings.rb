class CreateFeedings < ActiveRecord::Migration[5.0]
  def change
    create_table :feedings do |t|

      t.timestamps
    end
  end
end
