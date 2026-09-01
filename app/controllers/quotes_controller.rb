# app/controllers/quotes_controller.rb
class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  def index
    @quotes = Quote.all
  end

  def show
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to @quote, notice: "Quote ##{@quote.quote_num} was successfully created."
    else
      flash.now[:alert] = "Please fix the errors below to save the quote."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: "Quote ##{@quote.quote_num} was successfully updated."
    else
      flash.now[:alert] = "Please fix the errors below to update the quote."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy
    redirect_to quotes_path, notice: "Quote was successfully deleted."
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end

  # Strong parameters: explicitly permit attributes submitted by the view
  def quote_params
    params.require(:quote).permit(
      :quote_num,
      :customer_name,
      :total_amount,
      :expires_at,
      :notes,
      :approved
    )
  end
end