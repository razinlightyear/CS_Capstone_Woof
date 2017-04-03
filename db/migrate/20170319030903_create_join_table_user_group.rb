class CreateJoinTableUserGroup < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :groups do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      #t.index [:user_id, :group_id]
      #t.index [:group_id, :user_id]
    end
    #add_foreign_key :users_groups, :users
    #add_foreign_key :users_groups, :groups
  end
end
