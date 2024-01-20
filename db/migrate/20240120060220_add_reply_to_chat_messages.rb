class AddReplyToChatMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :chat_messages, :reply_to_message_id, :integer, :default => nil
  end
end
