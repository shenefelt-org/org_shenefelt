# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  before_action :set_customer, only: [:show]

  def index
    @customers = Customer.order(created_at: :desc)
  end

  def show
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to @customer, notice: "Customer was successfully created."
    else
      flash.now[:alert] = "Please fix the errors below to save the customer."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :company_name, :notes)
  end
end