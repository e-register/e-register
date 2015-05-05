class User < ActiveRecord::Base
  devise :database_authenticatable, :trackable

  validates_presence_of :name, :surname, :user_group

  belongs_to :user_group

  # Fixes a bug introduced with the multi-credential authentication:
  #  - Devise expects to find the password and the password hash in the User
  #    model, but they were moved to a separate relation
  attr_accessor :password, :encrypted_password

  # This Virtual Attribute is used to check the password according to the
  # correct username. The value is set in self.find_for_database_authentication
  # and used in valid_password?
  attr_accessor :username

  has_many :students, dependent: :destroy
  has_many :teachers, ->{ order(:klass_id, :subject_id) }, dependent: :destroy
  has_many :credentials, dependent: :destroy
  has_many :presences, foreign_key: :teacher_id, dependent: :destroy
  has_many :events, foreign_key: :teacher_id, dependent: :destroy
  has_many :signs, foreign_key: :teacher_id, dependent: :destroy
  has_many :notes, foreign_key: :teacher_id, dependent: :destroy

  # The user full name:
  # name: "Edoardo"
  # surname: "Morassutto"
  # full_name: "Edoardo Morassutto"
  def full_name
    "#{name} #{surname}".strip
  end

  # Fetch the classes of the user
  def klasses
    klasses = []
    students.includes(:klass).each { |stud| klasses.push(stud.klass) }
    teachers.includes(:klass).each { |teach| klasses.push(teach.klass) }
    klasses.to_a.uniq
  end

  # Fetch all the evaluations of the user
  def evaluations
    evals = []
    students.each { |stud| evals.concat(stud.evaluations) }
    teachers.each { |teach| evals.concat(teach.evaluations) }
    evals.sort { |a,b| a.date <=> b.date }
  end

  # Fetch the presence of the User: the student's one and the teachers one
  def presences
    # the presences of the teacher
    pres = Presence.where(teacher: self)
    # the presences of the student
    students.each { |stud| pres.concat(stud.presences) }
    # the presences of all the students in the classes where the teacher teaches
    teachers.each { |teach| pres.concat(teach.klass.presences) }
    pres.to_a.uniq
  end

  # Fetch the events of the User
  def events
    # the events created by the teacher
    events = Event.where(teacher: self)
    # the events of all the my classes (if I'm a student)
    students.each { |stud| events.concat(stud.klass.events) }
    # the events of all the my classes (if I'm a teacher)
    teachers.each { |teach| events.concat(teach.klass.events) }
    # remove the duplicates
    events.to_a.uniq
  end

  # Fetch the signs of the user
  def signs
    signs = Sign.where(teacher: self)
    students.each { |stud| signs.concat(stud.signs) }
    teachers.each { |teach| signs.concat(teach.signs) }
    signs.to_a.uniq
  end

  # Search the notes of the user
  def notes
    Note.unscoped.where.any_of({teacher: self}, {notable: self, visible: true})
  end

  # define helper methods for groups
  [ :admin?, :teacher?, :student? ].each do |group|
    define_method group do
      return user_group.name.downcase + '?' == group.to_s
    end
  end

  # Check if a user is in a user_group:
  # Params:
  #    group: can be a string or a symbol, the name of the group
  # Example:
  #   u.user_group? :admin
  def user_group?(group)
    user_group.name == group.to_s.capitalize
  end
end
