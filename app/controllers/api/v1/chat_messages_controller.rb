class Api::V1::ChatMessagesController < ApplicationController
  before_action :set_chat_room

  def index
    @chat_messages = @chat_room.chat_messages
  end

  def create
    @chat_message = @chat_room.chat_messages.new(chat_message_params)
    @chat_message.user_id = current_user.id
    if @chat_message.save
      Notifications::PushMessageNotification.call(@chat_message)
      render_json(data: @chat_message, status: 200)
    else
      render_json(status: 422, errors: @chat_message.errors.full_messages)
    end
  end

  private

  def set_chat_room
    @chat_room = current_user.chat_rooms.find(params[:chat_room_id])
  end

  def chat_message_params
    params.permit(*ChatMessage::PERMITTED_ATTRIBUTES)
  end
end
