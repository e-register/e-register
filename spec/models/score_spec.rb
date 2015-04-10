require 'rails_helper'

describe Score, type: :model do
  subject { create(:score) }

  it { is_expected.to respond_to(:value) }
  it { is_expected.to respond_to(:as_string) }
  it { is_expected.to respond_to(:is_counted) }

  it { is_expected.to be_valid }

  it 'is invalid without a string value' do
    score = build(:score, as_string: '')
    expect(score).not_to be_valid
  end

  it 'has the support for the ½ char' do
    score = create(:score_half)
    score.reload
    expect(score.as_string).to match(/½/)
  end
end
