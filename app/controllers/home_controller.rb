class HomeController < ApplicationController
  def index
    # Current.user is automatically populated by Rails 8 authentication
    @user = Current.user
  end
end
