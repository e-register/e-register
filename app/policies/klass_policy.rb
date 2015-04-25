class KlassPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user && (user.admin? || user.klasses.include?(record))
  end
end
