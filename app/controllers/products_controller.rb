class ProductsController < ApplicationController
  # Store browsing should be public; checkout still requires login
  allow_unauthenticated_access only: %i[index show]

  before_action :set_product, only: %i[show edit update destroy]
  before_action :require_admin!, only: %i[new create edit update destroy]

  def index
    @products = Product.active.order(created_at: :desc)
  end

  def show
    if params[:checkout] == "success" && params[:order_id].present?
      order = current_user&.orders&.find_by(id: params[:order_id])
      flash.now[:notice] = if order
        "Payment received. Order ##{order.id} is being confirmed."
      else
        "Payment submitted. You will receive a confirmation shortly."
      end
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      begin
        @product.sync_to_stripe!
        redirect_to @product, notice: "Product was successfully created."
      rescue Stripe::StripeError => e
        flash[:alert] = "Product saved, but Stripe integration failed: #{e.message}"
        redirect_to edit_product_path(@product)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Instead of deleting, safer for order history to deactivate
    @product.update(active: false)
    redirect_to products_url, notice: "Product was removed from the store."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :title,
      :description,
      :price_in_cents,
      :active
    )
  end

  def require_admin!
    return if current_user&.admin?

    redirect_to products_path, alert: "You are not authorized to manage products."
  end
end