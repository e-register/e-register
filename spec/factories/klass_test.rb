FactoryGirl.define do
  factory :klass_test do
    teacher
    date Date.new
    total_score 30.0
    evaluation_scale
    description 'A klass test'
  end
end
