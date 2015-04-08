require 'rails_helper'

describe Teacher, type: :model do
  subject { create(:teacher) }

  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:klass) }
  it { is_expected.to respond_to(:subject) }

  it 'checks the uniqueness of the tuple' do
    user = create(:user)
    klass = create(:klass)
    subject = create(:subject)

    create(:teacher, user: user, klass: klass, subject: subject)
    other = build(:teacher, user: user, klass: klass, subject: subject)

    expect(other).not_to be_valid
  end
end
