class PresencePolicy < ApplicationPolicy
  def show?
    return false unless user
    return true if user.admin?
    return true if record.teacher == user
    return true if (record.student.teachers & user.teachers).length > 0
    return true if record.student.user == user
    false
  end
end
