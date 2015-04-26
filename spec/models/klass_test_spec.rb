require 'rails_helper'

describe KlassTest, type: :model do
  subject { create(:klass_test) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:evaluation_scale) }
  it { is_expected.to respond_to(:evaluations) }

  it 'rounds the scores correctly' do
    test = create(:klass_test, total_score: 6.123564)

    expect(test.total_score).to eq(6.12)
  end
end
