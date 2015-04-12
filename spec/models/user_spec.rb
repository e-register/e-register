require 'rails_helper'

describe User, type: :model do
  subject { create(:user) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:surname) }
  it { is_expected.to respond_to(:user_group) }

  it 'is invalid if the name is missing' do
    user = build(:user, name: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid if the surname is missing' do
    user = build(:user, surname: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid if the user group is missing' do
    user = build(:user, user_group: nil)
    expect(user).to_not be_valid
  end

  it 'is invalid if the name is empty' do
    user = build(:user, name: '')
    expect(user).to_not be_valid
  end

  it 'is invalid if the surname is empty' do
    user = build(:user, surname: '')
    expect(user).to_not be_valid
  end

  it 'is student if the group is student' do
    student = build(:user_student)
    group = build(:user_group_student)

    expect(student.user_group).to eq(group)
  end

  it 'has students' do
    user = create(:user_student)

    students = Student.where(user: user)

    expect(user.students).to match_array(students)
  end

  it 'has credentials' do
    user = create(:user, num_credential: 2)
    expect(user.credentials.count).to eq(2)
  end

  it 'fetches the evaluations if the user is a student' do
    user = create(:user_student)

    evaluations = []
    user.students.each do |stud|
      evaluations << create(:evaluation, student: stud)
    end

    # a fake eval is other class
    create(:evaluation)
    # a fake eval in the same class
    create(:evaluation, teacher: create(:teacher, klass: user.students.first.klass))
    # a hidden eval
    create(:evaluation, student: user.students.first, visible: false)

    expect(user.evaluations).to match_array(evaluations)
  end

  it 'fetches the evaluations if the user is a teacher' do
    user = create(:user_teacher)

    evaluations = []
    user.teachers.each do |teach|
      evaluations << create(:evaluation, teacher: teach)
    end

    # a fake eval
    create(:evaluation)
    # an eval of someone
    create(:evaluation, teacher: create(:teacher))
    # an eval of his student but of someone
    create(:evaluation, teacher: create(:teacher), student: user.teachers.first.students.first)

    expect(user.evaluations).to match_array(evaluations)
  end
end
