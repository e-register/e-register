class EvaluationPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user && ((record.student.user == user && record.visible) || record.teacher.user == user || user.admin?)
  end

  def create?
    return false unless user
    return true if user.admin?
    return false unless user.teacher?

    @record = @record.teacher if record.is_a? Evaluation

    user.teachers.include?(record)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def student?
    return false unless user
    user.admin? || user.students.include?(record)
  end

  def teacher?
    return false unless user
    user.admin? || user.teachers.include?(record)
  end

  def new_group?
    teacher?
  end

  def permitted_attributes
    return [] unless user
    return [] unless user.admin? || user.teacher?

    @record = @record.teacher if record.is_a? Evaluation

    return [] unless user.admin? || user.teachers.include?(record)
    [:teacher_id, :student_id, :date, :score, :score_id, :evaluation_type_id, :visible, :description, :klass_test_id]
  end
end
