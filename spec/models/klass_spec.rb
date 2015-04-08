require 'rails_helper'

describe Klass do
  subject { create(:klass) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:detail) }

  it 'has the correct name' do
    klass = create(:klass, name: 'IVCis')
    expect(klass.name).to eq('IVCis')
  end

  it 'has an unique name' do
    klass = build(:klass, name: subject.name)
    expect(klass).not_to be_valid
  end

  it 'is not valid without a name' do
    klass = build(:klass, name: nil)
    expect(klass).not_to be_valid
  end

  # it 'has a coordinator'
  # it 'has the students'
  # it 'has the teachers'
end
