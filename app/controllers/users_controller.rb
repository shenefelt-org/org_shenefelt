class UsersController < ApplicationController
  before_action :require_authentication # push u to auth sso

  def new
    @user = User.new
    # GS Auth pundit
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    @user.save ? redirect_to(dashboard_path, notice: "User successfully created.") : render(:new, status: :unprocessable_entity)
  end

  private

  def user_params
    params.expect(user: [ :email_address, :admin ])
  end
end
