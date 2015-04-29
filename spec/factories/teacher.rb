FactoryGirl.define do
  factory :teacher do
    association :user, factory: :user_teacher
    klass
    association :subject, factory: :subject
  end
end
