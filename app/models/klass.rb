class Klass < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  # Search the students in this class. The users are already preloaded
  def students
    Student.where(klass: self).includes(:user)
  end

  # Search the teachers in this class. The users are already preloaded
  def teachers
    Teacher.where(klass: self).includes(:user)
  end

  # Search the presences of the students in this class
  def presences
    Presence.where(student: students)
  end
end
