class ChatRoom < ApplicationRecord
  PERMITTED_ATTRIBUTES =
    self.permitted_attributes +
    [{ chat_participants_attributes: %i[user_id]}]

  has_many :chat_participants, dependent: :destroy
  has_many :users, through: :chat_participants
  has_many :chat_messages, dependent: :destroy

  has_one :last_message, -> { order(id: :desc) }, class_name: 'ChatMessage'

  mount_uploader :image, ChatRoomImageUploader

  accepts_nested_attributes_for :chat_participants

  validate :must_greater_than_2_users

  private

  def must_greater_than_2_users
    return if chat_participants.map(&:user_id).uniq.size > 1

    errors.add(:chat_participants, 'Chat room must have at least two user.')
  end
end
