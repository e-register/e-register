require 'rails_helper'

describe Student, type: :model do
  subject { create(:student) }

  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:klass) }
  it { is_expected.to respond_to(:teachers) }
  it { is_expected.to respond_to(:evaluations) }

  it 'checks the uniqueness of the pair' do
    user = create(:user)
    klass = create(:klass)

    create(:student, user: user, klass: klass)
    other = build(:student, user: user, klass: klass)

    expect(other).not_to be_valid
  end

  it 'retrieves the teachers of the student' do
    user1 = create(:user_student, num_klass: 0)
    user2 = create(:user_teacher, num_klass: 0)
    user3 = create(:user_teacher, num_klass: 0)

    klass1 = create(:klass)
    klass2 = create(:klass)

    stud = create(:student, user: user1, klass: klass1)
    teach1 = create(:teacher, user: user2, klass: klass1)
    teach2 = create(:teacher, user: user3, klass: klass2)

    expect(stud.teachers).to match_array([teach1])
  end

  it 'filter the hidden evaluations' do
    user = create(:user_student)
    eval = create(:evaluation, student: user.students.first)
    create(:evaluation, student: user.students.first, visible: false)

    expect(user.students.first.evaluations).to match_array([eval])
  end
end
