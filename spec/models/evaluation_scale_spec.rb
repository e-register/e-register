require 'rails_helper'

describe EvaluationScale, type: :model do
  subject { create(:evaluation_scale) }

  it { is_expected.to respond_to(:checkpoints) }
  it { is_expected.to respond_to(:compute_score) }
  it { is_expected.to respond_to(:evaluations) }

  it 'has attribute checkpoints of kind of Hash' do
    expect(subject.checkpoints).to be_a(Hash)
  end

  it 'computes the correct score' do
    generate_scores

    scale = {
        checkpoints: [
            { percentage: 0.1, value: 3.0 },
            { percentage: 0.3, value: 4.0 },
            { percentage: 0.6, value: 6.0 },
            { percentage: 0.9, value: 8.0 }
        ]
    }
    evaluation_scale = create(:evaluation_scale, checkpoints: scale)

    cases = [
        [ 0.0, 1.0 ],
        [ 0.1, 3.0 ],
        [ 0.2, 3.5 ], # 3.5
        [ 0.3, 4.0 ],
        [ 0.4, 4.5 ], # 4.6
        [ 0.5, 5.5 ], # 5.4
        [ 0.6, 6.0 ],
        [ 0.7, 6.5 ], # 6.6
        [ 0.8, 7.5 ], # 7.4
        [ 0.9, 8.0 ],
        [ 0.95, 9.0 ],
        [ 1.0, 10.0 ],
    ]

    cases.each do |score, value|
      score = evaluation_scale.compute_score(score)
      expect(score.value).to eq(value)
    end
  end

  it 'does not compute the score if the items are invalid' do
    expect(subject.compute_score(-0.1)).to be_nil
    expect(subject.compute_score(1.1)).to be_nil
  end

  it 'prepare the checkpoints correctly' do
    points = [
        { 'percentage' => 0.0, 'value' => 1.0 },
        { 'percentage' => 1.0, 'value' => 10.0 },
    ]
    scale = create(:evaluation_scale, checkpoints: { 'checkpoints' => points })

    expect(scale.send(:prepare_points)).to eq(points)
  end
end
