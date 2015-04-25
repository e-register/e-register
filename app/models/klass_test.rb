class KlassTest < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :evaluation_scale
  has_many :evaluations, dependent: :restrict_with_error
end
