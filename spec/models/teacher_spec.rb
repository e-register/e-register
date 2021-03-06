require 'rails_helper'

describe Teacher, type: :model do
  subject { create(:teacher) }

  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:klass) }
  it { is_expected.to respond_to(:subject) }
  it { is_expected.to respond_to(:students) }
  it { is_expected.to respond_to(:klass_tests) }
  it { is_expected.to respond_to(:evaluations) }

  check_required_field :teacher, [:user, :klass, :subject]

  it 'checks the uniqueness of the tuple' do
    user = create(:user)
    klass = create(:klass)
    subject = create(:subject)

    create(:teacher, user: user, klass: klass, subject: subject)
    other = build(:teacher, user: user, klass: klass, subject: subject)

    expect(other).not_to be_valid
  end

  it 'retrieves the students of the teacher' do
    user1 = create(:user_teacher, num_klass: 0)
    user2 = create(:user_student, num_klass: 0)
    user3 = create(:user_student, num_klass: 0)

    klass1 = create(:klass)
    klass2 = create(:klass)

    teach = create(:teacher, user: user1, klass: klass1)
    stud1 = create(:student, user: user2, klass: klass1)
    create(:student, user: user3, klass: klass2)

    expect(teach.students).to match_array([stud1])
  end

  it 'fetches the correct presences' do
    teach = create(:teacher)
    student = create(:student, klass: teach.klass)

    pres = create(:presence, teacher: teach.user)

    # a fake presence
    create(:presence)
    # a presence of a student in the same class of the teacher
    create(:presence, student: student)

    expect(teach.presences).to match_array([pres])
  end

  it 'fetches the correct events' do
    teach = create(:teacher)

    event = create(:event, teacher: teach.user)

    # an event in the class of the teacher but not owned by him
    create(:event, klass: teach.klass)
    # a fake event
    create(:event)

    expect(teach.events).to match_array([event])
  end

  it 'fetches the correct signs' do
    teach = create(:teacher)

    sign1 = create(:sign, teacher: teach.user, klass: teach.klass, subject: teach.subject)
    sign2 = create(:sign, klass: teach.klass, subject: teach.subject)

    # a fake sign
    create(:sign)
    # a fake sign of the same user
    create(:sign, teacher: teach.user)

    expect(teach.signs).to match_array([sign1, sign2])
  end
end
