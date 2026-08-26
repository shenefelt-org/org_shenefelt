class FunkoPopsController < ApplicationController
    allow_unauthenticated_access only: [ :index, :show ]

    def index
        @funko_pops = FunkoPop.all
    end


    def new
        @funko_pop = FunkoPop.new
    end

    def create
        @funko_pop = FunkoPop.new(funko_pop_params)

        if @funko_pop.save 
            redirect_to funko_pops_path, notice: "Added #{@funko_pop.name}"
        else
            render :new, status: :unprocessable_entity
        end
    end

    
    def show
    end

    private

    def funko_pop_params
        params.require(:funko_pop).permit(
            :name,
            :box_num,
            :cost,
            :current_value,
            :limited_edition,
            :exclusive,
            :note
        )
  end

end
