FactoryGirl.define do
  factory :teacher do
    association :user, factory: :user_teacher, num_klass: 0
    klass
    association :subject, factory: :subject
  end
end
