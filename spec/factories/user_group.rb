FactoryGirl.define do
  factory :user_group do
    name 'Student'

    initialize_with { UserGroup.find_or_create_by(name: name) }

    factory :user_group_admin do
      name 'Admin'
    end

    factory :user_group_teacher do
      name 'Teacher'
    end

    factory :user_group_student do
      name 'Student'
    end
  end
end
