class Klass < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  # Return an array of the students in this class. The users are already preloaded
  def students
    Student.where(klass: self).includes(:user)
  end

  def teachers
    Teacher.where(klass: self).includes(:user)
  end
end
