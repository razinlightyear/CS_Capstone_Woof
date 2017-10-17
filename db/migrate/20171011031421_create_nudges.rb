class CreateNudges < ActiveRecord::Migration[5.0]
  def change
    create_table :nudges do |t|
      t.string :nudge_token
      t.references :user, foreign_key: true
      t.integer :response

      t.timestamps
    end
  end
end
