# GS use JWT encode for HS256 compliant token
class TokenController < ApplicationController
  def new
    # Pre-populate with logged-in user's email address
    @email = Current.user&.email_address
  end

  def create
    @email = params[:email].presence || Current.user&.email_address

    if @email.present?
      payload = { email: @email, exp: 24.hours.from_now.to_i }
      secret  = Rails.application.secret_key_base
      token   = JWT.encode(payload, secret, "HS256")

      TokenMailer.send_token(@email, token).deliver_now
    else
      render :new, status: :unprocessable_entity
    end
  end
end
