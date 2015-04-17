class Sign < ActiveRecord::Base
  belongs_to :teacher, class_name: User
  belongs_to :subject
  belongs_to :klass

  validates_presence_of :teacher, :subject, :klass, :date, :hour
end
