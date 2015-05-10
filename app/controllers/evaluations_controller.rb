class EvaluationsController < ApplicationController
  before_filter :fetch_evaluation, only: [:show, :edit, :update, :destroy]

  helper_method :teacher_policy

  def index
    authorize :evaluation

    if current_user.student?
      index_student
    elsif current_user.teacher?
      index_teacher
    elsif current_user.admin?
      index_admin
    end
  end

  def student
    @student = Student.find params[:student_id]
    not_authorized(:student?, @student) unless student_policy.student?

    @subjects = @student.klass.subjects
    @evaluations = student_evaluations @student
    @types = EvaluationType.all
    @fluid = true
  end

  def teacher
    @teacher = Teacher.find params[:teacher_id]
    not_authorized(:teacher?, @teacher) unless teacher_policy.teacher?

    @types = EvaluationType.all
    @fluid = true
    @evaluations = @teacher.evaluations.includes(:score, :klass_test)
    @students = teacher_data_student(@teacher)
    @data, @columns = teacher_data @teacher
  end

  def show
    authorize @evaluation
    @score_class = @evaluation.score_class
    @score = @evaluation.score.try(:as_string) || '?'
  end

  def new
    @teacher = Teacher.find params[:teacher_id]
    @evaluation = Evaluation.new(new_evaluation_params)
    @students = @teacher.klass.students.map { |s| [s.user.full_name, s.id] }
    prepare_instance_variables
    authorize @evaluation
  end

  def new_klass
    @teacher = Teacher.find params[:teacher_id]
    not_authorized(:new_group?, @teacher) unless teacher_policy.new_group?

    @students = @teacher.klass.students
    prepare_instance_variables
    prepare_new_klass_instance_variables
  end

  def create
    @teacher = Teacher.find params[:evaluation][:teacher_id]
    do_create(Evaluation, evaluation_params, new_evaluation_teacher_path(@teacher))
  end

  def create_klass
    EvaluationsBatch.new(params, current_user).process
    redirect_to evaluations_teacher_path(params[:teacher_id])
  end

  def edit
    @teacher = @evaluation.teacher
    @students = @teacher.klass.students.map { |s| [s.user.full_name, s.id] }
    prepare_instance_variables
    authorize @evaluation
  end

  def update
    @teacher = Teacher.find params[:evaluation][:teacher_id]
    do_update(@evaluation, evaluation_params) { |eval| edit_evaluation_path(eval) }
  end

  def destroy
    do_destroy(@evaluation, 'Evaluation')
  end

  private

  def index_student
    @students = current_user.students.includes(:klass)
    if @students.count == 1
      redirect_to evaluations_student_path(@students.first)
    else
      render 'index_student'
    end
  end

  def index_teacher
    @teachers = current_user.teachers.includes(:klass, :subject)
    if @teachers.count == 1
      redirect_to evaluations_teacher_path(@teachers.first)
    else
      render 'index_teacher'
    end
  end

  def index_admin
    @teachers = Teacher.includes(:klass, :user, :subject).
        to_a.sort_by { |x| x.klass.name }.group_by { |x| x.klass }
    render 'index_admin'
  end

  def fetch_evaluation
    @evaluation = Evaluation.find params[:id]
  end

  def evaluation_params
    eval_params = params.require(:evaluation).permit(teacher_policy.permitted_attributes)
    unless eval_params.empty?
      eval_params[:student] = Student.find_by id: eval_params[:student_id]
      eval_params[:score] = Score.find_by id: eval_params[:score_id]
    end
    eval_params
  end

  def new_evaluation_params
    {
        teacher: @teacher,
        date: Date.today,
        visible: true,
        evaluation_type: params[:type_id] ? EvaluationType.find(params[:type_id]) : EvaluationType.first,
        student_id: params[:student_id],
        klass_test_id: params[:klass_test_id]
    }
  end

  def prepare_instance_variables
    @scores = Score.all
    @types = EvaluationType.all
  end

  def prepare_new_klass_instance_variables
    @evaluation_type = @types.first
    @visible = true
    @description = ''
    @date = Date.today
    @klass_test = true
    @evals = {}
  end

  def student_policy
    @student_policy ||= EvaluationPolicy.new(current_user, @student)
  end

  def student_evaluations(student)
    student.evaluations.includes(:teacher).group_by { |e| e.teacher.subject }
  end

  def teacher_policy
    @teacher_policy ||= EvaluationPolicy.new(current_user, @teacher)
  end

  def teacher_data(teacher)
    TeacherEvaluationsGrid.new(teacher, @students, @types, @evaluations).data
  end

  def teacher_data_student(teacher)
    teacher.klass.students.to_a
  end
end
