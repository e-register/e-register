class Teacher < ActiveRecord::Base
  validates_uniqueness_of :user, scope: [:klass, :subject]

  belongs_to :user
  belongs_to :klass
  belongs_to :subject
end
