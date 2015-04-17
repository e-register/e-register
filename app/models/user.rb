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

  # Fetch the signs of the user
  def signs
    signs = Sign.where(teacher: self)
    students.each { |stud| signs.concat(stud.signs) }
    teachers.each { |teach| signs.concat(teach.signs) }
    signs.to_a.uniq
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
