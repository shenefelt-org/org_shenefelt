class HomeController < ApplicationController
  allow_unauthenticated_access only: [:ip]
  
  def index
    # Current.user is automatically populated by Rails 8 authentication
    @user = Current.user
  end

  def view_pokedex_button?
    # Example: Only show the button if the user is logged in and has a role of 'trainer'
    @user.present?
  end

  def about
  end

  def portfolio
  end

  def ip
    @ip = request.remote_ip
    @user_agent = request.user_agent

    respond_to do |format|
      # serve json by default unless on browser
      format.json { render json: {ip: @ip, agent: @user_agent} }
      format.html # render html view
      format.text { render plain: @ip}
    end
  end


end
