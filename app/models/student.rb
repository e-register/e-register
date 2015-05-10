class Student < ActiveRecord::Base
  validates_presence_of :user_id, :klass_id
  validates_uniqueness_of :user_id, scope: [:klass_id]

  belongs_to :user
  belongs_to :klass
  has_many :evaluations, -> { where(visible: true).order(:date) }, dependent: :destroy
  has_many :presences, dependent: :destroy
  has_many :notes, as: :notable

  delegate :events, to: :klass

  scope :ordered, -> { includes(:user).joins(:user).order('users.surname', 'users.name') }

  # Search all the teachers that taught in the same class of this student
  def teachers
    Teacher.where(klass: klass).includes(:user)
  end

  # Search all the signs in the class of the student
  def signs
    Sign.where(klass: klass)
  end
end
