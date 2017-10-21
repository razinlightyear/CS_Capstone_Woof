class AddGroupIdToNudges < ActiveRecord::Migration[5.0]
  def change
    add_reference :nudges, :group, foreign_key: true
  end
end
