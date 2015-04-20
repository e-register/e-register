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

  it 'has the events' do
    teacher = create(:user_teacher)
    student = create(:user_student)

    klass = create(:klass)

    # join the classes of the 2 users
    student.students.first.update(klass: klass)
    teacher.teachers.first.update(klass: klass)

    # only teacher
    event1 = create(:event, teacher: teacher, text: 'event1')
    # teacher and student
    event2 = create(:event, klass: klass, text: 'event2')
    # only student
    event3 = create(:event, klass: student.students.second.klass, text: 'event3')
    # only teacher
    event4 = create(:event, klass: teacher.teachers.second.klass, text: 'event4')
    # only teacher as owner, not the student (hidden)
    event5 = create(:event, teacher: teacher, visible: false, klass: klass, text: 'event5')

    # a fake event
    create(:event)

    # the events as a teacher
    expect(teacher.events).to match_array([event1, event2, event4, event5])
    # the events as a student
    expect(student.events).to match_array([event2, event3])
  end

  it 'fetches the signs as a student' do
    user = create(:user_student)
    student = user.students.first

    sign = create(:sign, klass: student.klass)

    # a fake sign
    create(:sign)

    expect(user.signs).to match_array([sign])
  end

  it 'fetches the signs as a teacher' do
    user = create(:user_teacher)
    teacher = user.teachers.first

    sign1 = create(:sign, teacher: user)
    sign2 = create(:sign, klass: teacher.klass, subject: teacher.subject)

    # some fake signs
    create(:sign)
    create(:sign, klass: teacher.klass)
    create(:sign, subject: teacher.subject)

    expect(user.signs).to match_array([sign1, sign2])
  end

  it 'fetches the notes' do
    user = create(:user)

    note1 = create(:note, teacher: user)
    note2 = create(:note, teacher: user, visible: false)
    note3 = create(:note, notable: user)

    # a fake note
    create(:note)
    # an hidden note
    create(:note, notable: user, visible: false)

    expect(user.notes).to match_array([note1, note2, note3])
  end

  describe 'has dynamic user_group methods' do
    before do
      @u1 = create(:user_student)
      @u2 = create(:user_teacher)
      @u3 = create(:user_admin)
    end

    it 'responds to methods' do
      expect(@u1).to respond_to(:admin?)
      expect(@u2).to respond_to(:admin?)
      expect(@u3).to respond_to(:admin?)

      expect(@u1).to respond_to(:student?)
      expect(@u2).to respond_to(:student?)
      expect(@u3).to respond_to(:student?)

      expect(@u1).to respond_to(:teacher?)
      expect(@u2).to respond_to(:teacher?)
      expect(@u3).to respond_to(:teacher?)

      expect(@u1).not_to respond_to(:foobar?)
    end

    it 'to student?' do
      expect(@u1).to be_student
      expect(@u2).not_to be_student
      expect(@u3).not_to be_student
    end
    it 'to teacher?' do
      expect(@u1).not_to be_teacher
      expect(@u2).to be_teacher
      expect(@u3).not_to be_teacher
    end
    it 'to admin?' do
      expect(@u1).not_to be_admin
      expect(@u2).not_to be_admin
      expect(@u3).to be_admin
    end

    it 'checks the user_groups correctly' do
      expect(@u1.user_group? :student).to be_truthy
      expect(@u2.user_group? :student).to be_falsey
      expect(@u3.user_group? :student).to be_falsey

      expect(@u1.user_group? 'teacher').to be_falsey
      expect(@u2.user_group? 'teacher').to be_truthy
      expect(@u3.user_group? 'teacher').to be_falsey

      expect(@u1.user_group? 'Admin').to be_falsey
      expect(@u2.user_group? 'Admin').to be_falsey
      expect(@u3.user_group? 'Admin').to be_truthy
    end
  end
end
