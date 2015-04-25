class Subject < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :evaluations, dependent: :restrict_with_error
  has_many :signs, dependent: :restrict_with_error
  has_many :teachers, dependent: :restrict_with_error
end
