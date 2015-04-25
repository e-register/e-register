class UsersController < ApplicationController
  before_filter :fetch_user

  def show
    raise Pundit::NotAuthorizedError unless @user

    authorize @user

    @klasses = @user.klasses
  end

  def edit
    authorize @user
  end

  def update
    do_update(@user, user_params) { |user| edit_user_path(user) }
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    do_create(User, user_params, new_user_path)
  end

  def destroy
    do_destroy(@user, 'User')
  end

  private
  def fetch_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def user_params
    params.require(:user).permit(policy(@user).permitted_attributes)
  end
end
