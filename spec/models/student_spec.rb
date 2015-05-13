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

    create(:teacher, user: user3, klass: klass2)

    expect(stud.teachers).to match_array([teach1])
  end

  it 'filter the hidden evaluations' do
    user = create(:user_student)

    eval = create(:evaluation, student: user.students.first)

    create(:evaluation, student: user.students.first, visible: false)

    expect(user.students.first.evaluations).to match_array([eval])
  end

  it 'fetches the presences' do
    stud1 = create(:student)
    stud2 = create(:student)
    stud3 = create(:student, klass: stud1.klass)

    pres = create(:presence, student: stud1)
    create(:presence, student: stud3)

    # a fake presence
    create(:presence, student: stud2)

    expect(stud1.presences).to match_array([pres])
  end

  it 'fetches the signs' do
    stud = create(:student)

    sign = create(:sign, klass: stud.klass)

    # a fake sign
    create(:sign)

    expect(stud.signs).to match_array([sign])
  end

  it 'fetches the notes' do
    stud = create(:student)

    note = create(:note, notable: stud)

    # a fake note
    create(:note)
    # an hidden note
    create(:note, notable: stud, visible: false)

    expect(stud.notes).to match_array([note])
  end

  it 'destroys scoped resources [BUG #25]' do
    stud = create(:student)
    eval = create(:evaluation, visible: false, student: stud)

    stud.destroy

    expect { eval.reload }.to raise_exception ActiveRecord::RecordNotFound
  end
end
