class EvaluationsController < ApplicationController
  before_filter :fetch_evaluation, only: [:show, :edit, :update, :destroy]

  def index
    authorize :evaluation

    if current_user.student?
      @students = current_user.students.includes(:klass)
      index_student
    elsif current_user.teacher?
      @teachers = current_user.teachers.includes(:klass, :subject)
      index_teacher
    elsif current_user.admin?
      render 'index_admin'
    end
  end

  def show
    authorize @evaluation
    @score_class = @evaluation.score_class
    @score = @evaluation.score.try(:as_string) || '?'
  end

  def new
    @teacher = Teacher.find params[:teacher_id]
    @evaluation = Evaluation.new(teacher: @teacher, date: Date.today, visible: true, evaluation_type: EvaluationType.first)
    @students = @teacher.klass.students.map { |s| [s.user.full_name, s.id] }
    prepare_instance_variables
    authorize @evaluation
  end

  def create
    @teacher = Teacher.find params[:evaluation][:teacher_id]
    do_create(Evaluation, evaluation_params, new_evaluation_teacher_path(@teacher))
  end

  def edit
    @teacher = @evaluation.teacher
    @students = @teacher.klass.students.map { |s| [s.user.full_name, s.id] }
    prepare_instance_variables
    authorize @evaluation
  end

  def update
    do_update(@evaluation, evaluation_params) { |eval| edit_evaluation_path(eval) }
  end

  def destroy
    do_destroy(@evaluation, 'Evaluation')
  end

  private

  def index_student
    if @students.count == 1
      redirect_to evaluations_student_path(@students.first)
    else
      render 'index_student'
    end
  end

  def index_teacher
    if @teachers.count == 1
      redirect_to evaluations_teacher_path(@teachers.first)
    else
      render 'index_teacher'
    end
  end

  def fetch_evaluation
    @evaluation = Evaluation.find params[:id]
  end

  def evaluation_params
    eval_params = params.require(:evaluation).permit(policy(@evaluation || :evaluation).permitted_attributes)
    unless eval_params.empty?
      eval_params[:student] = Student.find_by id: eval_params[:student]
      eval_params[:score] = Score.find_by id: eval_params[:score_id]
    end
    eval_params
  end

  def prepare_instance_variables
    @scores = Score.all
    @types = EvaluationType.all
  end
end
