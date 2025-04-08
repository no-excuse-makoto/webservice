class AddUniqueIndexToChatRooms < ActiveRecord::Migration[7.2]
  def change
    add_index :chat_rooms, [:user1_id, :user2_id], unique: true
    add_index :chat_rooms, [:user2_id, :user1_id], unique: true
  end
end
