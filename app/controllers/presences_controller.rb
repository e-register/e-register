class PresencesController < ApplicationController
  before_filter :fetch_presence, only: [:show]

  def show
    authorize @presence

    @today_presences = Presence.today_presences(@presence.student)
  end

  private

  def fetch_presence
    @presence = Presence.find(params[:id])
    raise ActiveRecord::RecordNotFound if @presence.student.klass_id != params[:klass_id].to_i
  end
end
