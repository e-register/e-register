class Klass < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :events, -> { where(visible: true) }
  has_many :signs

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

  # Search the today's presence of the class
  def today_presences
    Presence.today_presences(students)
  end

  # Search the today's signs
  def today_signs
    signs.where(date: Date.today)
  end

  # Search the today's events
  def today_events
    events.where(date: Date.today)
  end

  # Search the notes of the klass
  def notes
    Note.where(notable: self)
  end

end
