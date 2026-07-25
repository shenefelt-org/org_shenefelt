class TokenController < ApplicationController
  protect_from_forgery with: :exception
  def new
  end

  def create
    email = params[:email]

    # 24 hour jwt bear 
    reutrn nil unless email.present?

    payload = {email: email, exp: 24.hours.from_now.to_i}
    secret = Rails.application.secret_key_base
    token = JWT.encode(payload, secret, 'HS256')

    TokenMailer.send_token(email,token).deliver_now

  end
end
