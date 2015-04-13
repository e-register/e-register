class Justification < ActiveRecord::Base
  validates_uniqueness_of :reason
  validates_presence_of :reason
end
