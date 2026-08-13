class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create destroy]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  # def and bind session sso portal
  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

# sso destroy
def destroy
    # 1. Read token from Rails 8 DB session
    id_token = Current.session&.id_token

    # 2. Terminate local DB session
    Current.session&.destroy
    cookies.delete(:session_id)

    # invalidate Authentik session
    reset_session

    # 3. Construct Authentik logout URL with token hint
    query_params = {
      post_logout_redirect_uri: login_url
    }
    query_params[:id_token_hint] = id_token if id_token.present?

    authentik_logout_url = "https://sso.shenefelt.org/application/o/rails-app/end-session/?#{query_params.to_query}"

    # 4. Redirect out
    redirect_to authentik_logout_url, allow_other_host: true, status: :see_other
  end
end
