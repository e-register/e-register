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
