class Evaluation < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :student
  belongs_to :klass_test
  belongs_to :score
  belongs_to :evaluation_scale
  belongs_to :evaluation_type

  validates_presence_of :teacher_id, :student_id, :evaluation_type_id

  before_save :round_points

  def total_score
    super || (klass_test && klass_test.total_score)
  end

  def description
    return super unless super.blank?
    klass_test.try(:description).try(:to_s) || ""
  end

  def date
    super || (klass_test && klass_test.date)
  end

  def evaluation_scale
    return super if attribute(:evaluation_scale_id)
    klass_test && klass_test.evaluation_scale
  end

  def compute_score
    if evaluation_scale
      update!(score: evaluation_scale.compute_score(score_points / total_score))
    else
      raise Exception, "The Evaluation Scale cannot be nil"
    end
  end

  def score_class
    if !score
      'default'
    else
      score.score_class
    end
  end

  private

  def round_points
    self.total_score = total_score.round(2)   if total_score
    self.score_points = score_points.round(2) if score_points
  end
end
