FactoryGirl.define do
  factory :evaluation_type do
    name 'Written'

    # Prevent duplicates within the specs
    initialize_with { EvaluationType.find_or_create_by(name: name) }

    factory :evaluation_type_written do
      name 'Written'
    end

    factory :evaluation_type_oral do
      name 'Oral'
    end

    factory :evaluation_type_practical do
      name 'Practical'
    end
  end
end
