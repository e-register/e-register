class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  def home
  end
end
