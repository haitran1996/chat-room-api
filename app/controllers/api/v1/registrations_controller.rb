class Api::V1::RegistrationsController < ::DeviseTokenAuth::RegistrationsController
  skip_before_action :authenticate_user!

  def create
    super do |resource|
      resource
    end
  end

  protected

  def render_create_success
    render_json(data: resource_data)
  end

  def render_create_error
    render_json(status: 422, errors: @resource.errors.full_messages)
  end

  def render_update_success
    render_json(data: resource_data)
  end

  def render_update_error
    render_json(status: 422, errors: @resource.errors.full_messages)
  end

  def render_error(status, message, data = nil)
    render_json(status: status, errors: [message])
  end

  def render_authenticate_error
    render_json(status: 401, errors: [I18n.t('devise.failure.unauthenticated')])
  end
end