class UserGroup < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :users, dependent: :restrict_with_error
end
