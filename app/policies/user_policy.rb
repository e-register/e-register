class UserPolicy < ApplicationPolicy
  def show?
    user && user.admin? || record == user
  end
end
