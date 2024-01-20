class Api::V1::PasswordsController < ::DeviseTokenAuth::PasswordsController
  skip_before_action :authenticate_user!
end
