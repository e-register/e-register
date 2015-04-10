#encoding: utf-8

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

  it 'finds the correct score' do
    scores = {}
    [ 1.0, 3.0, 5.0, 7.0, 7.5 ].each do |value|
      scores[value] = create(:score, value: value)
    end

    expect(Score.from_value(1.0)).to eq(scores[1.0])

    expect(Score.from_value(1.5)).to eq(scores[1.0])
    expect(Score.from_value(2.0)).to eq(scores[1.0])

    expect(Score.from_value(5.0)).to eq(scores[5.0])

    expect(Score.from_value(4.999999)).to eq(scores[5.0])
    expect(Score.from_value(5.000001)).to eq(scores[5.0])

    expect(Score.from_value(7.45)).to eq(scores[7.5])

    expect(Score.from_value(0.0)).to eq(scores[1.0])
    expect(Score.from_value(10.0)).to eq(scores[7.5])
  end
end
