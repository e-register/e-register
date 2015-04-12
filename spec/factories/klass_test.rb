FactoryGirl.define do
  factory :klass_test do
    teacher
    date Date.new
    total_score 10.0
    evaluation_scale
    description 'Math test'
  end
end
