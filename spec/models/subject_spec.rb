require 'rails_helper'

describe Subject do
  subject { create(:subject) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to be_valid }

  check_unique_field(:subject, :name, 'Math')
  check_required_field(:subject, :name)
end
