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

  def set_user_by_token(mapping = nil)
    # determine target authentication class
    rc = resource_class(mapping)

    # no default user defined
    return unless rc

    # gets the headers names, which was set in the initialize file
    uid_name = DeviseTokenAuth.headers_names[:'uid']
    other_uid_name = DeviseTokenAuth.other_uid && DeviseTokenAuth.headers_names[DeviseTokenAuth.other_uid.to_sym]
    access_token_name = DeviseTokenAuth.headers_names[:'access-token']
    client_name = DeviseTokenAuth.headers_names[:'client']
    authorization_name = DeviseTokenAuth.headers_names[:"authorization"]

    # Read Authorization token and decode it if present
    decoded_authorization_token = decode_bearer_token(request.headers[authorization_name])

    # gets values from cookie if configured and present
    parsed_auth_cookie = {}
    if DeviseTokenAuth.cookie_enabled
      auth_cookie = request.cookies[DeviseTokenAuth.cookie_name]
      if auth_cookie.present?
        parsed_auth_cookie = JSON.parse(auth_cookie)
      end
    end

    # parse header for values necessary for authentication
    uid              = request.headers[uid_name] || params[uid_name] || parsed_auth_cookie[uid_name] || decoded_authorization_token[uid_name]
    other_uid        = other_uid_name && request.headers[other_uid_name] || params[other_uid_name] || parsed_auth_cookie[other_uid_name]
    @token           = DeviseTokenAuth::TokenFactory.new unless @token
    @token.token     ||= request.headers[access_token_name] || params[access_token_name] || parsed_auth_cookie[access_token_name] || decoded_authorization_token[access_token_name]
    @token.client ||= request.headers[client_name] || params[client_name] || parsed_auth_cookie[client_name] || decoded_authorization_token[client_name]

    # client isn't required, set to 'default' if absent
    @token.client ||= 'default'

    # check for an existing user, authenticated via warden/devise, if enabled
    if DeviseTokenAuth.enable_standard_devise_support
      devise_warden_user = warden.user(mapping)
      if devise_warden_user && devise_warden_user.tokens[@token.client].nil?
        @used_auth_by_token = false
        @resource = devise_warden_user
        # REVIEW: The following line _should_ be safe to remove;
        #  the generated token does not get used anywhere.
        # @resource.create_new_auth_token
      end
    end

    # user has already been found and authenticated
    return @resource if @resource && @resource.is_a?(rc)

    # ensure we clear the client
    unless @token.present?
      @token.client = nil
      return
    end

    # mitigate timing attacks by finding by uid instead of auth token
    user = (uid && rc.dta_find_by(uid: uid)) || (other_uid && rc.dta_find_by("#{DeviseTokenAuth.other_uid}": other_uid))
    scope = rc.to_s.underscore.to_sym

    if user && user.valid_token?(@token.token, @token.client)
      # user.token_expired?(@token.client) && user.create_new_auth_token(@token.client)
      # sign_in with bypass: true will be deprecated in the next version of Devise
      if respond_to?(:bypass_sign_in) && DeviseTokenAuth.bypass_sign_in
        bypass_sign_in(user, scope: scope)
      else
        sign_in(scope, user, store: false, event: :fetch, bypass: DeviseTokenAuth.bypass_sign_in)
      end
      return @resource = user
    else
      # zero all values previously set values
      @token.client = nil
      return @resource = nil
    end
  end

  def update_auth_header
    # cannot save object if model has invalid params
    return unless @resource && @token.client

    # Generate new client with existing authentication
    @token.client = nil unless @used_auth_by_token

    unless @resource.token_expired?(@token.client)
      # @used_auth_by_token && !DeviseTokenAuth.change_headers_on_each_request
      # should not append auth header if @resource related token was
      # cleared by sign out in the meantime
      return if @resource.reload.tokens[@token.client].nil?

      auth_header = @resource.build_auth_header(@token.token, @token.client)

      # update the response header
      response.headers.merge!(auth_header)

      # set a server cookie if configured
      if DeviseTokenAuth.cookie_enabled
        set_cookie(auth_header)
      end
    else
      unless @resource.reload.valid?
        @resource = @resource.class.find(@resource.to_param) # errors remain after reload
        # if we left the model in a bad state, something is wrong in our app
        unless @resource.valid?
          raise DeviseTokenAuth::Errors::InvalidModel, "Cannot set auth token in invalid model. Errors: #{@resource.errors.full_messages}"
        end
      end
      refresh_headers
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :device_token, :password, :email])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:device_token, :email, :password])
  end

  def render_json(data: nil, status: 200, errors: nil, message: nil)
    render json: {
      code: status,
      message: message,
      data: data,
      errors: errors
    }, status: status
  end

  helper_method :layout_jbuilder

  def layout_jbuilder(json, data: nil, status: 200, errors: nil, message: nil)
    json.code status
    json.message message
    if block_given?
      json.data do
        yield
      end
    else
      json.data data
    end
    json.errors errors
  end

  def render_authenticate_error
    render_json(status: 401, errors: [I18n.t('devise.failure.unauthenticated')])
  end
end
