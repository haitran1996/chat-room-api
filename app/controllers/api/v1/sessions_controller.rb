class Api::V1::SessionsController < ::DeviseTokenAuth::SessionsController
  skip_before_action :authenticate_user!

  def destroy
    super do |user|
      user.update device_token: nil
    end
  end
end
