class Api::V1::SessionsController < ::DeviseTokenAuth::SessionsController
  skip_before_action :authenticate_user!

  def create
    super do |user|
      user.update device_token: resource_params[:device_token]
    end
  end

  def destroy
    super do |user|
      user.update device_token: nil
    end
  end

  protected

  def render_create_success
    render_json(data: resource_data(resource_json: @resource.token_validation_response))
  end

  def render_destroy_success
    render_json
  end

  def render_error(status, message, data = nil)
    render_json(status: status, errors: [message])
  end

  def render_authenticate_error
    render_json(status: 401, errors: [I18n.t('devise.failure.unauthenticated')])
  end
end
