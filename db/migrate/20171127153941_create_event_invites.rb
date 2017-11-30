class CreateEventInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :event_invites do |t|
      t.references :event, foreign_key: true
      t.integer :inviter_id, :null => false
      t.integer :invitee_id, :null => false
      #t.boolean :accepted, null: false, default: false
      t.datetime :accepted_at
      t.datetime :declined_at
      t.string :invite_token
      t.timestamps
    end
    add_foreign_key :event_invites, :users, column: :inviter_id
    add_foreign_key :event_invites, :users, column: :invitee_id
    add_index :event_invites, :invite_token, unique: true
  end
end
