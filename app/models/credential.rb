class Credential < ActiveRecord::Base
  validates_presence_of :user_id, :username, :password_hash
  validates_uniqueness_of :username

  belongs_to :user

  def password=(password)
    self.password_hash = BCrypt::Password.create(password)
    self.save
  end

  def valid_password?(password)
    BCrypt::Password.new(password_hash) == password
  end
end
