# Rails.application.config.middleware.use OmniAuth::Builder do
#   # provider :line, "1657918257", "8f1db981c40c5168f1566a96e7172a29"
#   provider :line_custom, ENV.fetch('LINE_CHANNEL_ID'), ENV.fetch('LINE_SECRET'), scope: 'profile openid email'
# end
# OmniAuth.config.allowed_request_methods = [:get, :post]
