require 'rails_helper'

describe Klass do
  subject { create(:klass) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:detail) }

  it 'has the correct name' do
    klass = create(:klass, name: 'IVCis')
    expect(klass.name).to eq('IVCis')
  end

  it 'has an unique name' do
    klass = build(:klass, name: subject.name)
    expect(klass).not_to be_valid
  end

  it 'is not valid without a name' do
    klass = build(:klass, name: nil)
    expect(klass).not_to be_valid
  end

  # it 'has a coordinator'

  it 'has the students' do
    user1 = create(:user_student, num_klass: 0)
    user2 = create(:user_student, num_klass: 0)

    klass1 = create(:klass)
    klass2 = create(:klass)

    stud1 = create(:student, user: user1, klass: klass1)
    stud2 = create(:student, user: user1, klass: klass2)
    stud3 = create(:student, user: user2, klass: klass2)

    expect(klass1.students).to match_array([stud1])
    expect(klass2.students).to match_array([stud2, stud3])

    expect(klass1.students.map { |s| s.user }).to match_array([user1])
    expect(klass2.students.map { |s| s.user }).to match_array([user1, user2])
  end

  it 'has the teachers' do
    user1 = create(:user_teacher, num_klass: 0)
    user2 = create(:user_teacher, num_klass: 0)

    klass1 = create(:klass)
    klass2 = create(:klass)

    subject = create(:subject)

    teach1 = create(:teacher, user: user1, klass: klass1, subject: subject)
    teach2 = create(:teacher, user: user1, klass: klass2, subject: subject)
    teach3 = create(:teacher, user: user2, klass: klass2, subject: subject)

    expect(klass1.teachers).to match_array([teach1])
    expect(klass2.teachers).to match_array([teach2, teach3])

    expect(klass1.teachers.map { |s| s.user }).to match_array([user1])
    expect(klass2.teachers.map { |s| s.user }).to match_array([user1, user2])
  end
end
