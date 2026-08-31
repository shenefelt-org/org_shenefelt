module Webhooks
  class StripeController < ApplicationController
    # Stripe webhooks cannot use session cookies
    allow_unauthenticated_access only: :create
    skip_before_action :verify_authenticity_token, only: :create

    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret) ||
                        ENV["STRIPE_WEBHOOK_SECRET"]

      begin
        event = if endpoint_secret.present?
          Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
        else
          # Dev fallback only — set webhook_secret in production
          Stripe::Event.construct_from(JSON.parse(payload))
        end
      rescue JSON::ParserError => e
        Rails.logger.error("[StripeWebhook] Invalid payload: #{e.message}")
        head :bad_request
        return
      rescue Stripe::SignatureVerificationError => e
        Rails.logger.error("[StripeWebhook] Signature verification failed: #{e.message}")
        head :bad_request
        return
      end

      case event.type
      when "checkout.session.completed"
        handle_checkout_completed(event.data.object)
      when "checkout.session.expired"
        handle_checkout_expired(event.data.object)
      when "payment_intent.payment_failed"
        handle_payment_failed(event.data.object)
      else
        Rails.logger.info("[StripeWebhook] Unhandled event: #{event.type}")
      end

      head :ok
    end

    private

    def handle_checkout_completed(session)
      order = Order.find_by(id: session.metadata&.[]("order_id")) ||
              Order.find_by(stripe_checkout_session_id: session.id)
      return unless order

      order.mark_paid!(payment_intent_id: session.payment_intent)
    end

    def handle_checkout_expired(session)
      order = Order.find_by(stripe_checkout_session_id: session.id) ||
              Order.find_by(id: session.metadata&.[]("order_id"))
      return unless order
      return if order.status == "paid"

      order.update!(status: "canceled")
    end

    def handle_payment_failed(payment_intent)
      order = Order.find_by(stripe_payment_intent_id: payment_intent.id)
      return unless order
      return if order.status == "paid"

      order.update!(status: "failed")
    end
  end
end
