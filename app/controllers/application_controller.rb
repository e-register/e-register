class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_authorized

  before_filter :enable_profiler

  def home
    @home_blocks = APP_CONFIG['homepage'][current_user.user_group.name.downcase] if current_user
  end

  helper_method :current_user_username
  def current_user_username
    session[:username]
  end

  private

  def user_not_authorized
    raise if Rails.env.development?
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def enable_profiler
    if current_user.try(:user_group).try(:name) == 'Admin' || Rails.env.development?
      Rack::MiniProfiler.authorize_request
    end
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
      redirect_to block_given? ? yield(instance) : instance
    else
      flash[:alert] = instance.errors.full_messages.join("<br>").html_safe
      redirect_to error_path
    end
  end

  # Perform the update of a model
  # Params:
  #    instance: the instance to update
  #    klass_params: the params to update
  #    on_success: a proc to call if the update is successful and return the url to redirect to
  #    block: a block with a parameter that returns the path to redirect to in case of error
  def do_update(instance, klass_params, on_success = nil)
    authorize instance
    # TODO: if the authorization fails after that the changes are stored?
    success = instance.update_attributes(klass_params)
    authorize instance
    if success
      redirect_to on_success ? on_success.call(instance) : instance
    else
      flash[:alert] = instance.errors.full_messages.join("<br>").html_safe
      redirect_to yield(instance)
    end
  end

  # Perform the destroy of a model
  # Params:
  #    instance: the instance to destroy
  #    model_name: the name of the class of the model to destroy
  #    on_error: a proc with a parameter that returns the path to redirect to in case of error
  def do_destroy(instance, model_name, on_error = nil)
    authorize instance
    if instance.destroy
      redirect_to root_path, notice: "#{model_name} deleted successfully"
    else
      redirect_to on_error ? on_error.call(instance) : instance,
        alert: "Error deleting the #{model_name.downcase}"
    end
  end

  # Throws a NotAuthorized exception
  def not_authorized(query = nil, record = nil, policy = nil)
    raise NotAuthorizedError.new(query: query, record: record, policy: policy)
  end
end
