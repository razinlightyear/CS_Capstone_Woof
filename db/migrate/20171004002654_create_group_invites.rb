class CreateGroupInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :group_invites do |t|
      t.references :group, foreign_key: true
      t.integer :inviter_id, :null => false
      t.integer :invitee_id, :null => false
      #t.boolean :accepted, null: false, default: false
      t.datetime :accepted_at
      t.datetime :declined_at
      t.string :invite_token
      t.timestamps
    end
    add_foreign_key :group_invites, :users, column: :inviter_id
    add_foreign_key :group_invites, :users, column: :invitee_id
    add_index :group_invites, :invite_token, unique: true
  end
end
