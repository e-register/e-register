class EvaluationPolicy < ApplicationPolicy
  def index?
    user
  end
end
