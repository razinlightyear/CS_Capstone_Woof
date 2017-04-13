class CreateAroundMe < ActiveRecord::Migration[5.0]
  def change
    create_table :around_me do |t|
      # Google maps API stuff
      t.decimal :longitude, :precision => 15, :scale => 12
      t.decimal :latitude, :precision => 15, :scale => 12
      t.references :around_me_event, polymorphic: true, index: true
      t.timestamps
    end
  end
end
