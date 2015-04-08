FactoryGirl.define do
  factory :user_group do
    name 'Student'

    factory :user_group_admin do
      name 'Student'
    end

    factory :user_group_teacher do
      name 'Student'
    end

    factory :user_group_student do
      name 'Student'
    end
  end
end
