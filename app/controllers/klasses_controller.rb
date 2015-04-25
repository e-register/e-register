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

    @students = uniq_and_sort @klass.students
    @teachers = uniq_and_sort @klass.teachers
  end

  private
  def fetch_klass
    @klass = Klass.find(params[:id])
  end

  # Makes a list of student/teacher unique by user and sort by surname, name
  def uniq_and_sort(users)
    users.to_a.uniq { |x| x.user }.sort_by{ |x| [x.user.surname, x.user.name] }
  end
end
