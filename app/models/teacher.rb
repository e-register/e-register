class Teacher < ActiveRecord::Base
  validates_uniqueness_of :user, scope: [:klass, :subject]

  belongs_to :user
  belongs_to :klass
  belongs_to :subject
  has_many :klass_tests
  has_many :evaluations
  has_many :presences

  # Search all the students that are in the same class of this teacher
  def students
    Student.where(klass: klass).includes(:user)
  end

  # Search the presences created by the user
  def presences
    Presence.where(teacher: user)
  end
end
