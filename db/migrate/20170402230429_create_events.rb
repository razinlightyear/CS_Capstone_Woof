class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.references :pet, foreign_key: true
      t.references :pet_event, polymorphic: true, index: true
      t.timestamps
    end
  end
end
