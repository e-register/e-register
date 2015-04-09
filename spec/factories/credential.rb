FactoryGirl.define do
  factory :credential do
    user
    sequence(:username) { |n| "user#{n}" }
    password 'secret'
  end
end
