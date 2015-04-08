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
end
