require 'rails_helper'

describe UserGroup, type: :model do
  subject { create(:user_group) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:users) }

  it { is_expected.to be_valid }

  check_unique_field(:user_group, :name, 'Student', create_method: :new)
  check_required_field(:user_group, :name)

  it 'has the list of users' do
    group1 = create(:user_group_student)
    group2 = create(:user_group_teacher)

    user1 = create(:user, user_group: group1)
    user2 = create(:user, user_group: group1)
    user3 = create(:user, user_group: group2)

    expect(group1.users).to match_array([user1, user2])
    expect(group2.users).to match_array([user3])
  end
end
