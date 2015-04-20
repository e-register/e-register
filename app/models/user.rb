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

  has_many :students
  has_many :teachers
  has_many :credentials

  # The user full name:
  # name: "Edoardo"
  # surname: "Morassutto"
  # full_name: "Edoardo Morassutto"
  def full_name
    "#{name} #{surname}".strip
  end

  # Fetch all the evaluations of the user
  def evaluations
    evals = []
    students.each { |stud| evals.concat(stud.evaluations) }
    teachers.each { |teach| evals.concat(teach.evaluations) }
    evals
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

  # User group check
  def method_missing(m, *args, &block)
    return true if user_group.name.downcase + '?' == m.to_s
    return false if UserGroup.find_by(name: m.to_s[0..-2].capitalize)
    super
  end
  # User group check
  def respond_to?(m)
    return true if UserGroup.find_by(name: m.to_s[0..-2].capitalize)
    super
  end

  # Check if a user is in a user_group:
  # Params:
  #    group: can be a string or a symbol, the name of the group
  # Example:
  #   u.user_group? :admin
  def user_group?(group)
    user_group.name == group.to_s.capitalize
  end

  ########################
  # AUTHENTICATION STUFF #
  ########################

  # Checks if the password provided is correct for the current user. This uses
  # the :username virtual attribute to find the correct credential
  def valid_password?(password)
    credential = Credential.find_by(username: username)
    credential.valid_password?(password) if credential
  end

  # Prepare the user according to the username requested:
  #  - Find the credential with the specified username
  #  - Fetch the user of that credential
  #  - Inject in that user the provided username (as virtual attribute for
  #    `valid_password?`)
  def self.find_for_database_authentication(conditions)
    credential = Credential.find_by(conditions)
    user = credential.try(:user)
    user.username = conditions[:username] if user
    user
  end
end
