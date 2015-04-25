class KlassesController < ApplicationController
  before_filter :fetch_klass, except: :index

  def index
    authorize :klass
    @klasses = current_user.klasses
  end

  def show
    authorize @klass
    @today_presences = @klass.today_presences
    @today_signs = @klass.today_signs
    @today_events = @klass.today_events

    @students = @klass.students.to_a.uniq { |x|x.user }.
        sort_by{ |x| [x.user.surname, x.user.name] }
    @teachers = @klass.teachers.to_a.uniq{ |x| x.user }.
        sort_by{ |x| [x.user.surname, x.user.name] }
  end

  private
  def fetch_klass
    @klass = Klass.find(params[:id])
  end
end
