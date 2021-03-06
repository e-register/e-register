class PresencesController < ApplicationController
  before_filter :fetch_presence, only: [:show, :edit, :update, :destroy]

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @klass = Klass.find params[:klass_id]

    authorize Presence.new(klass: @klass)

    @presences = @klass.presences.where(date: @date).includes(:presence_type).group_by { |p| p.student_id }
    @students = @klass.students
  end

  def show
    authorize @presence
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

  def destroy
    on_error = ->(instance) { klass_presence_path(instance.student.klass, instance) }
    do_destroy(@presence, 'Presence', on_error)
  end

  private

  def fetch_presence
    @klass = Klass.find(params[:klass_id])
    @presence = Presence.find(params[:id])
    raise ActiveRecord::RecordNotFound if @presence.student.klass != @klass
  end

  def presence_params
    PresenceParams.presence_params(params, permitted_attributes, current_user, @presence)
  end

  def permitted_attributes
    policy(@presence || :presence).permitted_attributes
  end

  def new_presence_params
    PresenceParams.new_presence_params(params, @klass, current_user)
  end

  def prepare_instance_variables
    @students = @klass.students.map { |s| [s.user.full_name, s.id] }
    @presence_types = PresenceType.all
    @justifications = Justification.all
  end
end
