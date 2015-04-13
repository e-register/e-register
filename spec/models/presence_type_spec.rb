require 'rails_helper'

describe PresenceType, type: :model do
  subject { create(:presence_type) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:present) }

  check_unique_field(:presence_type, :name, 'Present', create_method: :new)
  check_required_field(:presence_type, :name)
end
