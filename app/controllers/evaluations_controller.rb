class EvaluationsController < ApplicationController
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
end
