class Api::V1::ChatRoomsController < ApplicationController
  def index
    @chat_rooms = current_user.chat_rooms.preload(:last_message)
  end

  def create
    @chat_room = current_user.chat_rooms.new(chat_room_params)
    @chat_room.chat_participants.new(user_id: current_user.id) if @chat_room.chat_participants.map(&:user_id).exclude?(current_user.id)
    if @chat_room.save
      render_json(data: @user, status: 200)
    else
      render_json(status: 422, errors: @user.errors.full_messages)
    end
  end

  private

  def chat_room_params
    params.permit(*ChatRoom::PERMITTED_ATTRIBUTES)
  end
end
