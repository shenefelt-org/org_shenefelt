class PokedexesController < ApplicationController
  before_action :set_pokedex, only: %i[ show edit update destroy ]

  # GET /pokedexes or /pokedexes.json
  def index
    @pokedexes = Pokedex.all
  end

  # GET /pokedexes/1 or /pokedexes/1.json
  def show
  end

  # GET /pokedexes/new
  def new
    @pokedex = Pokedex.new
  end

  # GET /pokedexes/1/edit
  def edit
  end

  # POST /pokedexes or /pokedexes.json
  def create
    @pokedex = Pokedex.new(pokedex_params)

    respond_to do |format|
      if @pokedex.save
        format.html { redirect_to @pokedex, notice: "Pokedex was successfully created." }
        format.json { render :show, status: :created, location: @pokedex }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @pokedex.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /pokedexes/1 or /pokedexes/1.json
  def update
    respond_to do |format|
      if @pokedex.update(pokedex_params)
        format.html { redirect_to @pokedex, notice: "Pokedex was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @pokedex }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @pokedex.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /pokedexes/1 or /pokedexes/1.json
  def destroy
    @pokedex.destroy!

    respond_to do |format|
      format.html { redirect_to pokedexes_path, notice: "Pokedex was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pokedex
      @pokedex = Pokedex.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pokedex_params
      params.expect(pokedex: [ :flavor_text, :pokemon_id ])
    end
end
