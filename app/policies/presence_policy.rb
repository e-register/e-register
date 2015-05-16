class PresencePolicy < ApplicationPolicy
  def show?
    return false unless user
    return true if user.admin?
    return true if record.teacher == user
    return true if (record.student.teachers & user.teachers).length > 0
    return true if record.student.user == user
    false
  end

  def new?
    return false unless user
    return true if user.admin?
    return true if (record.klass.teachers & user.teachers).length > 0
    false
  end

  def create?
    return false unless user
    return true if user.admin?
    return false unless user.teacher?
    return false unless record.student
    return true if (record.student.teachers & user.teachers).length > 0
    false
  end

  def permitted_attributes
    return [] unless user
    unless user.admin?
      return [] unless user.teacher?
      return [] if !record.is_a?(Symbol) && (record.student.teachers & user.teachers).length == 0
    end
    [:teacher_id, :student_id, :date, :hour, :presence_type_id, :justification_id, :note]
  end
end
