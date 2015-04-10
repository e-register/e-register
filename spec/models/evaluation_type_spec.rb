require 'rails_helper'

describe EvaluationType, type: :model do
  subject { create(:evaluation_type) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to be_valid }

  it 'has unique name' do
    create(:evaluation_type_written)
    type = build(:evaluation_type_written)
    expect(type).not_to be_valid
  end

  it 'is invalid without a name' do
    type = build(:evaluation_type, name: '')
    expect(type).not_to be_valid
  end
end
