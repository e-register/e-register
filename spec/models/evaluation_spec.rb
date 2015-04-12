require 'rails_helper'

describe Evaluation, type: :model do
  subject { create(:evaluation) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:student) }
  it { is_expected.to respond_to(:klass_test) }
  it { is_expected.to respond_to(:score) }
  it { is_expected.to respond_to(:evaluation_scale) }
  it { is_expected.to respond_to(:evaluation_type) }

  it 'returns the total score from klass_test if missing' do
    klass_test = create(:klass_test)

    subject.klass_test = klass_test
    subject.total_score = nil

    expect(subject.total_score).to eq(klass_test.total_score)
  end

  it 'returns the total score from evaluation even with klass_test' do
    klass_test = create(:klass_test)
    subject.klass_test = klass_test
    subject.total_score = 123

    expect(subject.total_score).to eq(123)
  end

  it 'returns nil if the total score is missing' do
    subject.total_score = nil
    subject.klass_test = nil

    expect(subject.total_score).to be_nil
  end


  it 'returns the klass_test description if missing' do
    klass_test = create(:klass_test)

    subject.klass_test = klass_test
    subject.description = nil

    expect(subject.description).to eq(klass_test.description)
  end

  it 'returns the description from evaluation even with klass_test' do
    klass_test = create(:klass_test)
    subject.klass_test = klass_test
    subject.description = 'BlaBlaBla'

    expect(subject.description).to eq('BlaBlaBla')
  end

  it 'returns an empty string if the description is missing' do
    klass_test = create(:klass_test)
    subject.klass_test = nil
    subject.description = nil

    expect(subject.description).to eq('')
  end

  it 'computes the correct score' do
    generate_scores

    evaluation = create(:evaluation, score_points: 8.0, total_score: 10.0)

    evaluation.score = nil
    evaluation.evaluation_scale = create(:evaluation_scale)

    evaluation.compute_score

    expect(evaluation.score).to eq(Score.from_value(8.0))
  end

  it 'raises error if the score cannot be computed' do
    evaluation = create(:evaluation, score_points: 8.0, total_score: 10.0)
    evaluation.score = nil
    evaluation.evaluation_scale = nil

    expect { evaluation.compute_score }.to raise_exception
  end
end
