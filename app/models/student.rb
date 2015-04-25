class Student < ActiveRecord::Base
  validates_presence_of :user, :klass
  validates_uniqueness_of :user, scope: [:klass]

  belongs_to :user
  belongs_to :klass
  has_many :evaluations, -> { where(visible: true) }, dependent: :destroy
  has_many :presences, dependent: :destroy
  has_many :notes, as: :notable

  delegate :events, to: :klass

  # Search all the teachers that taught in the same class of this student
  def teachers
    Teacher.where(klass: klass).includes(:user)
  end

  # Search all the signs in the class of the student
  def signs
    Sign.where(klass: klass)
  end
end
