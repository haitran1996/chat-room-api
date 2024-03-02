class AddImageToChatRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :chat_rooms, :image, :string
  end
end
