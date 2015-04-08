FactoryGirl.define do
  factory :klass do
    sequence(:name) { |n| "class#{n}" }
    detail 'A very interesting class'
  end
end
