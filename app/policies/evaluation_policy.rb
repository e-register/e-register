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

    user.teachers.include?(record.teacher)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    return [] unless user
    return [] unless user.admin? || user.teacher?
    return [] unless user.admin? || user.teachers.include?(record.teacher)
    [:teacher_id, :student, :date, :score, :score_id, :evaluation_type_id, :visible, :description]
  end
end
