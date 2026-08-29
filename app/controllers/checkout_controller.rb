class CheckoutController < ApplicationController
  def create
    # 1. Find the product from the button click
    @product = Product.find(params[:product_id])

    # 2. Create the new order instantly
    @order = Order.create!(
      status: 'pending', 
      total_amount: @product.price_in_cents
    )
    
    # 3. Link the product to the order
    OrderItem.create!(
      order: @order, 
      product: @product, 
      quantity: 1, 
      price_at_purchase: @product.price_in_cents
    )

    # 4. Generate the Stripe Checkout Session
    session = Stripe::Checkout::Session.create({
      mode: 'payment',
      line_items: [{
        price_data: {
          currency: 'usd',
          unit_amount: @product.price_in_cents,
          product_data: {
            name: @product.title,
            description: @product.description
          }
        },
        quantity: 1
      }],
      metadata: { order_id: @order.id },
      success_url: root_url(checkout: 'success'),
      cancel_url: root_url(checkout: 'canceled')
    })

    # 5. Redirect to Stripe
    redirect_to session.url, allow_other_host: true
  end
end