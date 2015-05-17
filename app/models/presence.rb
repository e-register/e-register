class Presence < ActiveRecord::Base
  belongs_to :teacher, class_name: User
  belongs_to :student
  belongs_to :presence_type
  belongs_to :justification

  attr_accessor :klass

  validates_presence_of :teacher_id, :student_id, :date, :hour, :presence_type_id

  scope :daily_presences, ->(stud, date) { where(student: stud, date: date).order(:hour) }
  scope :today_presences, ->(stud) { daily_presences(stud, Date.today) }

  def self.last_today_presence(stud)
    today_presences(stud).last
  end
end
