class KlassTest < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :evaluation_scale
  has_many :evaluations, dependent: :restrict_with_error

  before_save :round_points

  private

  def round_points
    self.total_score = total_score.round(2) if total_score
  end
end
