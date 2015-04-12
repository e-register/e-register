class Evaluation < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :student
  belongs_to :klass_test
  belongs_to :score
  belongs_to :evaluation_scale
  belongs_to :evaluation_type

  def total_score
    attribute(:total_score) || (klass_test && klass_test.total_score)
  end

  def description
    return attribute(:description) unless attribute(:description).blank?
    klass_test.try(:description).try(:to_s) || ""
  end

  def compute_score
    if evaluation_scale
      self.score = evaluation_scale.compute_score(score_points / total_score)
      self.save!
    else
      raise Exception, "The Evaluation Scale cannot be nil"
    end
  end
end
