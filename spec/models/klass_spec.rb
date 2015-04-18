require 'rails_helper'

describe Klass do
  subject { create(:klass) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:detail) }

  check_unique_field(:klass, :name, 'Class name')
  check_required_field(:klass, :name)

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

  it 'fetch the presences' do
    stud1 = create(:student)
    stud2 = create(:student)
    stud3 = create(:student, klass: stud1.klass)

    pres1 = create(:presence, student: stud1)
    pres2 = create(:presence, student: stud3)

    # a fake presence
    create(:presence, student: stud2)

    expect(stud1.klass.presences).to match_array([pres1, pres2])
  end

  it 'fetch the today\'s presences' do
    stud1 = create(:student)
    stud2 = create(:student, klass: stud1.klass)

    absent = create(:presence_type_absent)
    present = create(:presence_type_present)

    create(:presence, student: stud1, date: Date.yesterday, hour: 1, presence_type: absent)
    create(:presence, student: stud2, date: Date.yesterday, hour: 5, presence_type: present)

    pres1 = create(:presence, student: stud1, date: Date.today, hour: 1, presence_type: present)
    pres2 = create(:presence, student: stud1, date: Date.today, hour: 4, presence_type: absent)
    pres3 = create(:presence, student: stud2, date: Date.today, hour: 3, presence_type: present)

    # a fake presence
    create(:presence)

    expect(stud1.klass.today_presences).to eq([pres1, pres3, pres2])
  end

  it 'has the events' do
    klass = create(:klass)

    event = create(:event, klass: klass)

    # a fake event
    create(:event)
    # a hidden event
    create(:event, klass: klass, visible: false)

    expect(klass.events).to match_array([event])
  end

  it 'fetches the notes' do
    klass = create(:klass)

    note = create(:note, notable: klass)

    # a fake note
    create(:note)
    # an hidden note
    create(:note, notable: klass, visible: false)

    expect(klass.notes).to match_array([note])
  end
end
