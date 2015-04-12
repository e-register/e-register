class KlassTest < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :evaluation_scale
  has_many :evaluations
end
