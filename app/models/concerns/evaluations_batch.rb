class EvaluationsBatch
  attr_accessor :params
  attr_accessor :current_user

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def process
    prepare

    # for each student create a new evaluation
    params[:group].each do |student_id, data|
      @evaluations << build_evaluation(student_id.to_i, data)
    end
    # remove the missing evaluations
    @evaluations.compact!

    # if requested create the klass_test
    insert_klass_test if params[:klass_test] && @evaluations.length > 0

    # insert the data into the db
    Evaluation.import(@evaluations, validate: false)
  end

  private

  def prepare
    @teacher = Teacher.find params[:teacher_id]
    @teacher_policy = EvaluationPolicy.new(current_user, @teacher)
    @permitted_attributes = @teacher_policy.permitted_attributes

    @base_params = params.permit(@permitted_attributes)
    # if there will be a klass_test, skip these params (only overridden)
    @base_params.except!(:date, :description) if params[:klass_test]

    @students = Student.find(params[:group].keys).group_by { |x| x.id }
    @evaluations = []
  end

  def build_evaluation(student_id, data)
    student = @students[student_id].first

    evaluation = Evaluation.new(@base_params)
    evaluation.student = student
    evaluation = insert_attributes(evaluation, data)

    # if a record is invalid, stop all the process
    unless evaluation_valid(evaluation, student)
      raise Pundit::NotAuthorizedError.new(query: :create?, record: evaluation, policy: nil)
    end

    evaluation
  end

  def insert_attributes(evaluation, data)
    # if the score is missing skip the evaluation
    return nil if !data.keys.include?('score_id') || data['score_id'].blank?

    @permitted_attributes.each do |attr|
      # fetch the column information
      next unless (col = Evaluation.columns_hash[attr.to_s])

      val = data[attr]

      # if the column accepts boolean values, don't skip missing parameters
      if col.type == :boolean
        evaluation[attr] = val.present?
      elsif val.present?
        evaluation[attr] = val
      end
    end

    evaluation
  end

  def insert_klass_test
    klass_test = KlassTest.create({
      teacher: @teacher,
      date: params['date'],
      description: params['description']
    })
    @evaluations.each { |e| e.klass_test = klass_test }
  end

  def evaluation_valid(evaluation, student)
    return true unless evaluation
    evaluation.valid? && EvaluationPolicy.new(current_user, evaluation).create? && student.klass_id == @teacher.klass_id
  end
end
