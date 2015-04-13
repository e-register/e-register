require 'rails_helper'

describe Presence, type: :model do
  subject { create(:presence) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:student) }
  it { is_expected.to respond_to(:date) }
  it { is_expected.to respond_to(:hour) }
  it { is_expected.to respond_to(:presence_type) }
  it { is_expected.to respond_to(:justification) }
  it { is_expected.to respond_to(:note) }
end
