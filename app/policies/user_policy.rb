class UserPolicy < ApplicationPolicy
  def show?
    user && user.admin? || record == user
  end

  def update?
    user && user.admin?
  end

  def create?
    user && user.admin?
  end

  def destroy?
    user && user.admin?
  end

  def permitted_attributes
    if user && user.admin?
      [:name, :surname, :user_group_id]
    else
      []
    end
  end
end
