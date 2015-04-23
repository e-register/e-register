class KlassesController < ApplicationController
  def index
    authorize :klass
    @klasses = current_user.klasses
  end
end
