class EvaluationParams
  def self.evaluation_params(params, permitted_attributes)
    eval_params = params.require(:evaluation).permit(permitted_attributes)
    unless eval_params.empty?
      eval_params[:student] = Student.find eval_params[:student_id]
      eval_params[:score] = Score.find_by(id: eval_params[:score_id])
      insert_klass_test(eval_params) if eval_params[:klass_test_id].present?
    end
    eval_params
  end

  def self.new_evaluation_params(params, teacher)
    klass_test = params[:klass_test_id] ?
        KlassTest.find(params[:klass_test_id]) :
        nil

    {
        teacher: teacher,
        date: klass_test.try(:date) || Date.today,
        visible: true,
        evaluation_type: params[:type_id] ? EvaluationType.find(params[:type_id]) : EvaluationType.first,
        student_id: params[:student_id],
        klass_test_id: params[:klass_test_id],
        description: klass_test.try(:description) || ''
    }
  end

  private

  def self.insert_klass_test(eval_params)
    klass_test =  KlassTest.find eval_params[:klass_test_id]
    eval_params[:description] = nil if eval_params[:description] == klass_test.description
    eval_params[:date] = nil        if Date.parse(eval_params[:date]) == klass_test.date
  end
end
