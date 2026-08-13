# app/controllers/sso_controller.rb
# frozen_string_literal: true

require "json"
require "net/http"

class SsoController < ApplicationController
  allow_unauthenticated_access

  def start
    cfg = authentik_config
    state = SecureRandom.hex(24)
    nonce = SecureRandom.hex(24)

    cookies.signed[:oidc_state] = cookie_payload(state)
    cookies.signed[:oidc_nonce] = cookie_payload(nonce)
    Rails.logger.info("[SSO] start state=#{state}")

    query = {
      client_id: cfg.fetch(:client_id),
      redirect_uri: cfg.fetch(:redirect_uri),
      response_type: "code",
      scope: "openid email profile",
      state: state,
      nonce: nonce
    }.to_query

    redirect_to "https://sso.shenefelt.org/application/o/authorize/?#{query}",
                allow_other_host: true
  end

  def callback
    cfg = authentik_config
    Rails.logger.info("[SSO] callback params=#{params.except(:controller, :action).inspect}")

    if params[:error].present?
      return fail_sso(params[:error_description].presence || params[:error])
    end

    expected_state = cookies.signed[:oidc_state]
    cookies.delete(:oidc_state)
    cookies.delete(:oidc_nonce)

    if expected_state.blank? || params[:state].to_s != expected_state.to_s
      Rails.logger.error("[SSO] bad state expected=#{expected_state.inspect} got=#{params[:state].inspect}")
      return fail_sso("invalid state")
    end

    return fail_sso("missing authorization code") if params[:code].blank?

    token = exchange_code(params[:code], cfg)
    Rails.logger.info("[SSO] token ok keys=#{token.keys.inspect}")

    info = fetch_userinfo(token.fetch("access_token"))
    Rails.logger.info("[SSO] userinfo=#{info.inspect}")

    email = info["email"].to_s.strip.downcase
    uid   = info["sub"].to_s

    return fail_sso("Authentik did not provide an email") if email.blank?
    return fail_sso("Authentik did not provide sub") if uid.blank?

    user = User.find_by(provider: "openid_connect", uid: uid)
    user ||= User.find_by(email: email) if email.present?
    user ||= User.find_by(email_address: email) if email.present?

    if user
      user.provider       = "openid_connect"
      user.uid            = uid
      user.email          = email
      user.email_address  = email
      user.password       = SecureRandom.hex(32) if user.password_digest.blank?
      user.save!
      Rails.logger.info("[SSO] linked user id=#{user.id} email=#{user.email} email_address=#{user.email_address}")
    else
      user = User.create!(
        email: email,
        email_address: email,
        provider: "openid_connect",
        uid: uid,
        password: SecureRandom.hex(32)
      )
      Rails.logger.info("[SSO] created user id=#{user.id} email=#{user.email} email_address=#{user.email_address}")
    end

    # Establish Rails 8 Authentication database session
    start_new_session_for(user)

    # Store Authentik ID token directly in DB record (prevents 502 cookie bloat)
    Current.session&.update!(id_token: token["id_token"])

    redirect_to root_url, notice: "Signed in with SSO"
  rescue => e
    Rails.logger.error("[SSO] #{e.class}: #{e.message}\n#{e.backtrace.first(12).join("\n")}")
    fail_sso(e.message)
  end

  def failure
    fail_sso(params[:message].presence || "unknown error")
  end

  private

  def fail_sso(message)
    redirect_to new_session_path, alert: "SSO failed: #{message}"
  end

  def cookie_payload(value)
    {
      value: value,
      httponly: true,
      same_site: :lax,
      secure: true,
      path: "/",
      expires: 10.minutes.from_now
    }
  end

  def authentik_config
    Rails.application.credentials.fetch(:authentik)
  end

  def exchange_code(code, cfg)
    uri = URI("https://sso.shenefelt.org/application/o/token/")
    res = Net::HTTP.post_form(uri, {
      grant_type: "authorization_code",
      code: code,
      redirect_uri: cfg.fetch(:redirect_uri),
      client_id: cfg.fetch(:client_id),
      client_secret: cfg.fetch(:client_secret)
    })
    raise "Token exchange failed (#{res.code}): #{res.body}" unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end

  def fetch_userinfo(access_token)
    uri = URI("https://sso.shenefelt.org/application/o/userinfo/")
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    raise "Userinfo failed (#{res.code}): #{res.body}" unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end
end
