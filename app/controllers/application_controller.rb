class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound, with: :user_not_authorized

  def home
  end

  helper_method :current_user_username
  def current_user_username
    session[:username]
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
