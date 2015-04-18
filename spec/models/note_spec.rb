require 'rails_helper'

describe Note, type: :model do
  subject { create(:note) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:notable) }
  it { is_expected.to respond_to(:date) }
  it { is_expected.to respond_to(:visible) }
  it { is_expected.to respond_to(:text) }
end
