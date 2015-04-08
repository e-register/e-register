class Student < ActiveRecord::Base
  validates_presence_of :user, :klass
  validates_uniqueness_of :user, scope: [:klass]

  belongs_to :user
  belongs_to :klass

  # Search all the teachers that taught in the same class of this student
  def teachers
    Teacher.where(klass: klass).includes(:user)
  end
end
