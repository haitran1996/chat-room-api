class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  alias_method :authenticate_user!, :authenticate_api_v1_user!
  alias_method :current_user, :current_api_v1_user

  respond_to :json

  def home
    render file: 'app/views/firebase.html'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :device_token, :password, :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:device_token, :email, :password])
  end
end
