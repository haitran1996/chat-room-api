class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable
        # :omniauthable, omniauth_providers: [:google]
  include DeviseTokenAuth::Concerns::User
end
