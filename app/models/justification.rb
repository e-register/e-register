class Justification < ActiveRecord::Base
  validates_uniqueness_of :reason
  validates_presence_of :reason

  has_many :presences, dependent: :restrict_with_error
end
