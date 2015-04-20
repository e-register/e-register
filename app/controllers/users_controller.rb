class UsersController < ApplicationController
  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    authorize @user

    @klasses = @user.klasses
  end

  # def edit
  # end
  #
  # def update
  # end
  #
  # def new
  # end
  #
  # def create
  # end
  #
  # def delete
  # end
  #
  # def destroy
  # end
end
