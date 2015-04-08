require 'rails_helper'

describe UserGroup, type: :model do
  subject { create(:user_group) }

  it { is_expected.to respond_to(:name) }

  it { is_expected.to be_valid }

  it 'has the correct name' do
    user_group = build(:user_group_student)
    expect(user_group.name).to eq('Student')
  end

  it 'has a unique name' do
    sub = create(:user_group_student)
    other = build(:user_group_student)
    expect(other).not_to be_valid
  end

  it 'is not valid without a name' do
    user_group = build(:user_group, name: nil)
    expect(user_group).not_to be_valid
  end

  # it 'has the list of users'
end
