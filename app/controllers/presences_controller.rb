class PresencesController < ApplicationController
  before_filter :fetch_presence, only: [:show, :edit, :update]

  def show
    authorize @presence

    @today_presences = Presence.today_presences(@presence.student)
  end

  def new
    @klass = Klass.find params[:klass_id]
    @presence = Presence.new new_presence_params
    prepare_instance_variables
    authorize @presence
  end

  def create
    do_create(Presence, presence_params, new_klass_presence_path) do |presence|
      klass_presence_path(presence.student.klass, presence)
    end
  end

  def edit
    prepare_instance_variables
    authorize @presence
  end

  def update
    success = ->(instance) { klass_presence_path(instance.student.klass, instance) }
    do_update(@presence, presence_params, success) do |instance|
      edit_klass_presence_path(@klass, instance)
    end
  end

  private

  def fetch_presence
    @klass = Klass.find(params[:klass_id])
    @presence = Presence.find(params[:id])
    raise ActiveRecord::RecordNotFound if @presence.student.klass != @klass
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

  def prepare_instance_variables
    @students = @klass.students.map { |s| [s.user.full_name, s.id] }
    @presence_types = PresenceType.all
  end
end
