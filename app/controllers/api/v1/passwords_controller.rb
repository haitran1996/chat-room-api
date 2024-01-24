class Api::V1::PasswordsController < ::DeviseTokenAuth::PasswordsController
  skip_before_action :authenticate_user!

  protected

  def render_create_success
    render_json(message: success_message('passwords', @email))
  end

  def render_create_error(errors)
    render_json(errors: errors.full_messages, status: 400)
  end

  def render_update_success
    render_json(data: resource_data, message: I18n.t('devise_token_auth.passwords.successfully_updated'))
  end

  def render_update_error
    render_json(errors: @resource.errors.full_messages, status: 422)
  end

  def render_error(status, message, data = nil)
    render_json(status: status, errors: [message])
  end

  def render_authenticate_error
    render_json(status: 401, errors: [I18n.t('devise.failure.unauthenticated')])
  end
end
