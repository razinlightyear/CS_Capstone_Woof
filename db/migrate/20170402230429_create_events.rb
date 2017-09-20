class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.references :pet, foreign_key: true
      t.string :type, :null => false
      t.boolean :is_around_me, :null => false, :default => false
      t.decimal :longitude, :precision => 15, :scale => 12
      t.decimal :latitude, :precision => 15, :scale => 12
      t.timestamps
    end
  end
end
