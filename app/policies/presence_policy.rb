class PresencePolicy < ApplicationPolicy
  def index?
    return false unless user
    return true if user.admin?
    return false unless user.teacher?
    return true if user.klasses.include? record.klass
    false
  end

  def show?
    return false unless user
    return true if user.admin? || record.teacher == user || record.student.user == user
    return true if (record.student.teachers & user.teachers).length > 0
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

  def update?
    return false unless user
    return true if user.admin?
    return false unless user == record.teacher
    return false unless record.student
    return true if (record.student.teachers & user.teachers).length > 0
    false
  end

  def destroy?
    create?
  end

  def permitted_attributes
    return [] unless user
    unless user.admin?
      return [] unless user.teacher?
      return [] if record != :presence && (record.student.teachers & user.teachers) == []
    end
    [:teacher_id, :student_id, :date, :hour, :presence_type_id, :justification_id, :note]
  end
end
