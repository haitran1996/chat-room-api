class User < ApplicationRecord
  PERMITTED_ATTRIBUTES = self.permitted_attributes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :validatable
        # :omniauthable, omniauth_providers: [:google]
  include DeviseTokenAuth::Concerns::User

  mount_uploader :image, ImageUploader

  has_many :chat_participants
  has_many :chat_rooms, through: :chat_participants

  def token_is_current?(token, client)
    # ghetto HashWithIndifferentAccess
    expiry     = tokens[client]['expiry'] || tokens[client][:expiry]
    token_hash = tokens[client]['token'] || tokens[client][:token]
    previous_token_hash = tokens[client]['previous_token'] || tokens[client][:previous_token]

    return true if (
      # ensure that expiry and token are set
      expiry && token &&
      # ensure that the token is valid
      (
        # check if the latest token matches
        does_token_match?(token_hash, token) ||

        # check if the previous token matches
        does_token_match?(previous_token_hash, token)
      )
    )
  end

  def token_expired?(client)
    expiry = tokens[client]['expiry'] || tokens[client][:expiry]
    DateTime.strptime(expiry.to_s, '%s') < Time.zone.now
  end
end
