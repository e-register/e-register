FactoryGirl.define do
  factory :teacher do
    user
    klass
    association :subject, factory: :subject
  end
end
