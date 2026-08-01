class HomeController < ApplicationController
  def index
    # Current.user is automatically populated by Rails 8 authentication
    @user = Current.user
  end

  def view_pokedex_button?
    # Example: Only show the button if the user is logged in and has a role of 'trainer'
    @user.present?
  end


end
