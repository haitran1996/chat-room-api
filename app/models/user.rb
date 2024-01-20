class User < ApplicationRecord
  PERMITTED_ATTRIBUTES = self.permitted_attributes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable
        # :omniauthable, omniauth_providers: [:google]
  include DeviseTokenAuth::Concerns::User

  mount_uploader :image, ImageUploader

  has_many :chat_participants
  has_many :chat_rooms, through: :chat_participants
end
