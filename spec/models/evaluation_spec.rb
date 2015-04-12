require 'rails_helper'

describe Evaluation, type: :model do
  subject { create(:evaluation) }

  it { is_expected.to respond_to(:teacher) }
  it { is_expected.to respond_to(:student) }
  it { is_expected.to respond_to(:klass_test) }
  it { is_expected.to respond_to(:score) }
  it { is_expected.to respond_to(:evaluation_scale) }
  it { is_expected.to respond_to(:evaluation_type) }

  attributes_override_check(base_class: 'evaluation',
                            base_attribute: 'total_score',
                            super_attribute: 'klass_test',
                            base_value: 123)
  attributes_override_check(base_class: 'evaluation',
                            base_attribute: 'description',
                            super_attribute: 'klass_test',
                            base_value: 'BlaBlaBla',
                            default_value: '')
  attributes_override_check(base_class: 'evaluation',
                            base_attribute: 'date',
                            super_attribute: 'klass_test',
                            base_value: Date.yesterday)
  attributes_override_check(base_class: 'evaluation',
                            base_attribute: 'evaluation_scale',
                            super_attribute: 'klass_test',
                            base_value: FactoryGirl.build(:evaluation_scale),
                            save_base_value: true)

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
    evaluation.klass_test = nil

    expect { evaluation.compute_score }.to raise_exception
  end
end
