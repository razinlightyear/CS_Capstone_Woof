class AddChatToGroups < ActiveRecord::Migration[5.0]
  def change
    add_reference :groups, :chat, foreign_key: true
  end
end
