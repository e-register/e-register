require 'rails_helper'

describe Subject do
  subject { create(:subject) }

  it { is_expected.to respond_to(:name) }

  it { is_expected.to be_valid }

  it 'has the correct name' do
    subject = build(:subject, name: 'math')
    expect(subject.name).to eq('math')
  end

  it 'has a unique name' do
    sub = create(:subject, name: 'math')
    other = build(:subject, name: 'math')
    expect(other).not_to be_valid
  end

  it 'is not valid without a name' do
    klass = build(:subject, name: nil)
    expect(klass).not_to be_valid
  end
end
