class KlassPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user && (user.admin? || user.klasses.include?(record))
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
      [:name, :detail]
    else
      []
    end
  end
end
