class PresencesController < ApplicationController
  before_filter :fetch_presence, only: [:show]

  def show
    authorize @presence

    @today_presences = Presence.today_presences(@presence.student)
  end

  def new
    @klass = Klass.find params[:klass_id]
    @presence = Presence.new new_presence_params
    @students = @klass.students.map { |s| [s.user.full_name, s.id] }
    @presence_types = PresenceType.all
    authorize @presence
  end

  def create
    do_create(Presence, presence_params, new_klass_presence_path) do |presence|
      klass_presence_path(presence.student.klass, presence)
    end
  end

  private

  def fetch_presence
    @presence = Presence.find(params[:id])
    raise ActiveRecord::RecordNotFound if @presence.student.klass_id != params[:klass_id].to_i
  end

  def presence_params
    params.require(:presence).permit(policy(@presence || :presence).permitted_attributes).merge({
      teacher_id: current_user.id
    })
  end

  def new_presence_params
    {
        teacher: current_user,
        date: Date.today,
        hour: 1,
        presence_type_id: PresenceType.first.id,
        klass: @klass
    }
  end
end
