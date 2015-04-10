FactoryGirl.define do
  factory :score do
    value 8.0
    as_string '8'
    is_counted true

    factory :score_insufficient do
      value 5.0
      as_string '5'
    end

    factory :score_half do
      value 8.5
      as_string '8 ½'
    end

    factory :score_uncounted do
      value 0
      as_string 'Good'
      is_counted false
    end
  end
end
