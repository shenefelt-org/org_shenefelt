class CheckoutController < ApplicationController
  # Auth is already required by Authentication concern on ApplicationController.
  # Explicitly keep it required for checkout.
  # allow_unauthenticated_access is intentionally NOT used here.

  def create
    @product = Product.find_by(id: params[:product_id], active: true)

    unless @product
      redirect_back fallback_location: products_path, alert: "That product is unavailable."
      return
    end

    unless current_user
      # Safety net if auth is skipped elsewhere
      session[:return_to_after_authenticating] = product_url(@product)
      redirect_to new_session_path, alert: "Please sign in to complete checkout."
      return
    end

    result = nil

    ActiveRecord::Base.transaction do
      @order = current_user.orders.create!(
        status: "pending",
        total_amount: @product.price_in_cents
      )

      @order.order_items.create!(
        product: @product,
        quantity: 1,
        price_at_purchase: @product.price_in_cents
      )

      stripe_session = Stripe::Checkout::Session.create(
        mode: "payment",
        customer_email: current_user.email_address,
        line_items: [
          {
            price_data: {
              currency: "usd",
              unit_amount: @product.price_in_cents,
              product_data: {
                name: @product.title,
                description: @product.description.to_s.truncate(500)
              }
            },
            quantity: 1
          }
        ],
        metadata: {
          order_id: @order.id,
          user_id: current_user.id,
          product_id: @product.id
        },
        success_url: product_url(@product, checkout: "success", order_id: @order.id),
        cancel_url: product_url(@product, checkout: "canceled")
      )

      @order.update!(stripe_checkout_session_id: stripe_session.id)
      result = stripe_session
    end

    redirect_to result.url, allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found."
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: products_path, alert: "Could not start checkout: #{e.record.errors.full_messages.to_sentence}"
  rescue Stripe::StripeError => e
    Rails.logger.error("[Checkout] Stripe error: #{e.message}")
    redirect_back fallback_location: products_path, alert: "Payment could not be started. Please try again."
  end
end
