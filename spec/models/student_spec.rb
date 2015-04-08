require 'rails_helper'

describe Student, type: :model do
  subject { create(:student) }

  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:klass) }

  it 'checks the uniqueness of the pair' do
    user = create(:user)
    klass = create(:klass)

    create(:student, user: user, klass: klass)
    other = build(:student, user: user, klass: klass)

    expect(other).not_to be_valid
  end
end
