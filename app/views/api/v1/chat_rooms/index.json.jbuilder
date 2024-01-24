# json.array! @chat_rooms, partial: 'chat_room', as: :chat_room
layout_jbuilder(json) do
  json.array! @chat_rooms do |chat_room|
    json.(chat_room, *chat_room.attributes.keys)
    json.users chat_room.users
    json.last_message chat_room.last_message
  end
end
