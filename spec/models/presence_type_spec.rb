require 'rails_helper'

describe PresenceType, type: :model do
  subject { create(:presence_type) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:present) }

  it 'has unique name' do
    valid = create(:presence_type_present)
    invalid = PresenceType.new(name: valid.name)

    expect(invalid).not_to be_valid
  end

  it 'is invalid without a name' do
    invalid = build(:presence_type, name: '')
    expect(invalid).not_to be_valid
  end
end
