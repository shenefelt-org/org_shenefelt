# frozen_string_literal: true

require "omniauth"
require "omniauth_openid_connect"

Rails.application.config.middleware.use OmniAuth::Builder do
  authentik = Rails.application.credentials.fetch(:authentik)

  provider :openid_connect,
           name: :openid_connect,
           scope: [:openid, :email, :profile],
           response_type: :code,
           discovery: true,
           uid_field: "sub",
           issuer: authentik.fetch(:issuer),
           client_options: {
             identifier: authentik.fetch(:client_id),
             secret: authentik.fetch(:client_secret),
             redirect_uri: authentik.fetch(:redirect_uri)
           }
end

# TEMP for debugging: allow GET so address-bar hits work.
# After SSO works, change back to %i[post] only.
OmniAuth.config.allowed_request_methods = %i[get post]
OmniAuth.config.silence_get_warning = true
