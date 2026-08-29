class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    # Only show active products to standard visitors
    @products = Product.where(active: true)
  end

  def show
    # Renders the show.html.erb we built earlier
  end

  def new
    @product = Product.new
    # Renders the new.html.erb we built earlier
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
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
    # Instead of deleting, it's safer for order history to just deactivate
    @product.update(active: false)
    redirect_to products_url, notice: "Product was removed from the store."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :description, :price_in_cents, :stripe_product_id, :stripe_price_id, :active)
  end
end