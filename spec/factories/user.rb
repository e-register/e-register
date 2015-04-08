FactoryGirl.define do
  factory :user do
    name 'Edoardo'
    surname 'Morassutto'
    user_group

    factory :user_admin do
      association :user_group, factory: :user_group_admin
    end

    factory :user_teacher do
      association :user_group, factory: :user_group_teacher
    end

    factory :user_student do
      association :user_group, factory: :user_group_student
    end
  end
end
