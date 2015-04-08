class User < ActiveRecord::Base
  validates_presence_of :name, :surname, :user_group

  belongs_to :user_group

  has_many :students
  has_many :teachers
end
