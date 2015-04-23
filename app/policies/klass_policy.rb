class KlassPolicy < ApplicationPolicy
  def index?
    user
  end
end
