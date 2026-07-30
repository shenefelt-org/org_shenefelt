class OmniauthCallbacksController < ApplicationController
  allow_unauthenticated_access

  def callback
    auth = request.env["omniauth.auth"]
    raise "Missing omniauth.auth" unless auth

    user = User.from_omniauth(auth)
    start_new_session_for(user)
    redirect_to after_authentication_url, notice: "Signed in with SSO"
  rescue => e
    Rails.logger.error("[OmniAuth] #{e.class}: #{e.message}")
    redirect_to new_session_path, alert: "SSO failed: #{e.message}"
  end

  def failure
    redirect_to new_session_path, alert: "SSO failed: #{params[:message]}"
  end
end
