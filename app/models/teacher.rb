class Teacher < ActiveRecord::Base
  validates_presence_of :user_id, :klass_id, :subject_id
  validates_uniqueness_of :user_id, scope: [:klass_id, :subject_id]

  belongs_to :user
  belongs_to :klass
  belongs_to :subject
  has_many :klass_tests, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  has_many :presences, dependent: :destroy

  # Search all the students that are in the same class of this teacher
  def students
    Student.where(klass: klass).ordered
  end

  # Search the presences created by the user
  def presences
    Presence.where(teacher: user)
  end

  # Search the events created by the teacher
  def events
    Event.where(teacher: user)
  end

  # Search the signs of the pair klass-subject
  def signs
    Sign.where(subject: subject, klass: klass)
  end
end
