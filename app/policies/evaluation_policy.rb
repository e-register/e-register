class EvaluationPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user && ((record.student.user == user && record.visible) || record.teacher.user == user || user.admin?)
  end
end
