class Student < ActiveRecord::Base
  validates_presence_of :user, :klass
  validates_uniqueness_of :user, scope: [:klass]

  belongs_to :user
  belongs_to :klass
  has_many :evaluations, -> { where(visible: true) }
  has_many :presences

  # Search all the teachers that taught in the same class of this student
  def teachers
    Teacher.where(klass: klass).includes(:user)
  end

  def last_today_presence
    Presence.where(student: self, date: Date.today).order(:hour).last
  end
end
