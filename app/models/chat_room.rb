class ChatRoom < ApplicationRecord
  PERMITTED_ATTRIBUTES =
    self.permitted_attributes +
    [{ chat_participants_attributes: %i[user_id]}]

  has_many :chat_participants, dependent: :destroy
  has_many :users, through: :chat_participants
  has_many :chat_messages, dependent: :destroy

  has_one :last_message, -> { order(id: :desc) }, class_name: 'ChatMessage'

  accepts_nested_attributes_for :chat_participants
end
