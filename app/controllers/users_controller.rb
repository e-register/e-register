class UsersController < ApplicationController
  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    raise Pundit::NotAuthorizedError unless @user

    authorize @user

    @klasses = @user.klasses
    # @subjects = @user.subjects
  end
end
