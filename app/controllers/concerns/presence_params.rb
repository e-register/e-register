class PresenceParams
  def self.presence_params(params, permitted_attributes, teacher, presence)
    presence_params = params.require(:presence).permit(permitted_attributes)
    presence_params[:teacher_id] = teacher.id

    insert_justification(presence_params, presence) if presence_params[:justification_id]

    presence_params
  end

  def self.new_presence_params(params, klass, teacher)
    {
        teacher: teacher,
        date: params[:date] || Date.today,
        hour: params[:hour] || 1,
        presence_type_id: params[:presence_type_id] || PresenceType.first.id,
        student_id: params[:student_id],
        klass: klass
    }
  end

  private

  def self.insert_justification(presence_params, presence)
    if presence_params[:justification_id] == '0'
      presence_params[:justified_at] = nil
    else
      presence_params[:justified_at] = presence.justified_at || Date.today
    end
    presence_params[:justification_id] = nil if ['0', '-1'].include? presence_params[:justification_id]
  end
end
