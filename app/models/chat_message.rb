class ChatMessage < ApplicationRecord
  PERMITTED_ATTRIBUTES = self.permitted_attributes

  # association
  has_one :reply_to_message, class_name: 'ChatMessage', :foreign_key => :id
  belongs_to :user
  belongs_to :chat_room
end
