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
    do_index(students, 'student')
  end

  def index_teacher
    teachers = current_user.teachers.includes(:klass, :subject)
    do_index(teachers, 'teacher')
  end

  def index_admin
    teachers = Teacher.includes(:klass, :user, :subject).
        to_a.sort_by { |x| x.klass.name }.group_by { |x| x.klass }
    @base.instance_variable_set :@teachers, teachers
    render 'index_admin'
  end

  def do_index(collection, model)
    if collection.count == 1
      redirect_to @base.send("evaluations_#{model}_path", collection.first)
    else
      @base.instance_variable_set("@#{model.pluralize}", collection)
      render "index_#{model}"
    end
  end

  def method_missing(*arg, &blk)
    @base.send(*arg, &blk)
  end
end
