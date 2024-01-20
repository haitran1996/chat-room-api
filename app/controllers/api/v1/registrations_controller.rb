class Api::V1::RegistrationsController < ::DeviseTokenAuth::RegistrationsController
  skip_before_action :authenticate_user!

  def create
    super do |resource|
      resource
    end
  end
end