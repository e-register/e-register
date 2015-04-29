class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound, with: :user_not_authorized

  def home
    @home_blocks = APP_CONFIG['homepage'][current_user.user_group.name.downcase] if current_user
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

  protected

  # Perform the creation of a model
  # Params:
  #   klass: the constant of the model to create
  #   klass_params: the hash to use to create the model
  #   error_path: the path to redirect to in case of error
  def do_create(klass, klass_params, error_path)
    instance = klass.new klass_params
    authorize instance, :create?
    if instance.save
      redirect_to instance
    else
      flash[:alert] = instance.errors.full_messages.join("<br>").html_safe
      redirect_to error_path
    end
  end

  # Perform the update of a model
  # Params:
  #    instance: the instance to update
  #    klass_params: the params to update
  #    block: a block with a parameter that returns the path to redirect to in case of error
  def do_update(instance, klass_params)
    authorize instance
    if instance.update_attributes(klass_params)
      redirect_to instance
    else
      flash.now[:alert] = instance.errors.full_messages.join("<br>").html_safe
      redirect_to yield(instance)
    end
  end

  # Perform the destroy of a model
  # Params:
  #    instance: the instance to destroy
  #    model_name: the name of the class of the model to destroy
  def do_destroy(instance, model_name)
    authorize instance
    if instance.destroy
      redirect_to root_path, notice: "#{model_name} deleted successfully"
    else
      redirect_to instance, alert: "Error deleting the #{model_name.downcase}"
    end
  end
end
