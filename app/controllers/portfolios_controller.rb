class PortfoliosController < ApplicationController
    allow_unauthenticated_access only: [ :index, :show, :ip_addr, :abt ]

    def index 
    end

    def show 
    end

    def ip_addr
        @ip = request.remote_ip
        @user_agent = request.user_agent

        respond_to do |format|
          # serve json by default unless on browser
          format.json { render json: { ip: @ip, agent: @user_agent } }
          format.html # render html view
          format.text { render plain: @ip }
        end
    end

    def about_me
    end

    

    
end
