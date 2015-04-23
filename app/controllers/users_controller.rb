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
    authorize @user
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      flash.now[:alert] = @user.errors.full_messages.join("<br>").html_safe
      redirect_to edit_user_path(@user)
    end
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new user_params
    authorize @user, :create?
    if @user.save
      redirect_to @user
    else
      flash.now[:alert] = @user.errors.full_messages.join("<br>").html_safe
      redirect_to new_user_path
    end
  end

  def destroy
    authorize @user
    if @user.destroy
      redirect_to root_path, notice: 'User deleted successfully'
    else
      redirect_to @user, alert: 'Error deleting the user'
    end
  end

  private
  def fetch_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def user_params
    params.require(:user).permit(policy(@user).permitted_attributes)
  end
end
