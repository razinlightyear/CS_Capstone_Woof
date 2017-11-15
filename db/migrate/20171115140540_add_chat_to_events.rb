class AddChatToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :chat, foreign_key: true
  end
end
