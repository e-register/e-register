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

  def edit
    authorize @klass
  end

  def update
    authorize @klass
    if @klass.update_attributes(klass_params)
      redirect_to @klass
    else
      flash.now[:alert] = @klass.errors.full_messages.join("<br>").html_safe
      redirect_to edit_klass_path(@klass)
    end
  end

  private
  def fetch_klass
    @klass = Klass.find(params[:id])
  end

  # Makes a list of student/teacher unique by user and sort by surname, name
  def uniq_and_sort(users)
    users.to_a.uniq { |x| x.user }.sort_by{ |x| [x.user.surname, x.user.name] }
  end

  def klass_params
    params.require(:klass).permit(policy(@klass).permitted_attributes)
  end
end
