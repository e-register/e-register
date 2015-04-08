class Student < ActiveRecord::Base
  validates_presence_of :user, :klass
  validates_uniqueness_of :user, scope: [:klass]

  belongs_to :user
  belongs_to :klass
end
