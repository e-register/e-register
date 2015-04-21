class UsersController < ApplicationController
  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    authorize @user

    @klasses = @user.klasses
  end
end
