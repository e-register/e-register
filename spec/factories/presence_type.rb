FactoryGirl.define do
  factory :presence_type do
    name 'Present'
    description 'The student is in the class'
    present true

    initialize_with { PresenceType.find_or_create_by(name: name) }

    factory :presence_type_present do
    end

    factory :presence_type_absent do
      name 'Absent'
      description 'The student is absent'
      present false
    end
  end
end
