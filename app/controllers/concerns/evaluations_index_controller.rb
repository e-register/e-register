class EvaluationsIndexController
  attr_reader :current_user

  def initialize(current_user, base)
    @current_user = current_user
    @base = base
  end

  def index
    if current_user.student?
      index_student
    elsif current_user.teacher?
      index_teacher
    elsif current_user.admin?
      index_admin
    end
  end

  protected

  def index_student
    students = current_user.students.includes(:klass)
    if students.count == 1
      @base.redirect_to @base.evaluations_student_path(students.first)
    else
      @base.instance_variable_set :@students, students
      @base.render 'index_student'
    end
  end

  def index_teacher
    teachers = current_user.teachers.includes(:klass, :subject)
    if teachers.count == 1
      @base.redirect_to @base.evaluations_teacher_path(teachers.first)
    else
      @base.instance_variable_set :@teachers, teachers
      @base.render 'index_teacher'
    end
  end

  def index_admin
    teachers = Teacher.includes(:klass, :user, :subject).
        to_a.sort_by { |x| x.klass.name }.group_by { |x| x.klass }
    @base.instance_variable_set :@teachers, teachers
    @base.render 'index_admin'
  end
end
