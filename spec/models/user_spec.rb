require 'rails_helper'

describe User, type: :model do
  subject { create(:user) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:surname) }
  it { is_expected.to respond_to(:user_group) }

  check_required_field(:user, [ :name, :surname, :user_group ])

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

  it 'fetches the presences of the user as student' do
    user = create(:user_student)
    student = user.students.first

    create(:teacher, klass: student.klass)

    pres = create(:presence, student: student)
    # a fake presence
    create(:presence)
    # a presence of a user's teacher
    create(:presence, teacher: student.teachers.first.user)

    expect(user.presences).to match_array([pres])
  end

  it 'fetches the presences of the user as teacher' do
    user = create(:user_teacher)
    teacher = user.teachers.first

    stud1 = create(:student, klass: teacher.klass)
    stud2 = create(:student)

    pres = []
    pres << create(:presence, teacher: user)
    pres << create(:presence, student: stud1)

    # fake presences
    create(:presence)
    create(:presence, student: stud2)

    expect(user.presences).to match_array(pres)
  end
end
