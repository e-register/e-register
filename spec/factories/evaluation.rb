FactoryGirl.define do
  factory :evaluation do
    teacher { FactoryGirl.create(:teacher, klass: FactoryGirl.create(:klass)) }
    student { FactoryGirl.create(:student, klass: teacher.try(:klass) || FactoryGirl.create(:klass)) }
    date Date.today
    klass_test
    association :score, value: 8, as_string: '8'
    score_points 8.0
    total_score 10.0
    evaluation_scale nil
    association :evaluation_type, factory: :evaluation_type_written
    description 'Math test'
    visible true
  end
end
