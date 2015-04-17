class Event < ActiveRecord::Base
  belongs_to :teacher, class_name: User
  belongs_to :klass

  validates_presence_of :teacher, :klass, :date, :text
end
