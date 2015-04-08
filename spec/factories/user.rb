FactoryGirl.define do
  factory :user do
    name 'Edoardo'
    surname 'Morassutto'
    user_group

    factory :user_admin do
      association :user_group, factory: :user_group_admin
    end

    factory :user_teacher do
      transient do
        num_klass 2
      end

      association :user_group, factory: :user_group_teacher

      after(:create) do |user, evaluator|
        klasses = create_list(:klass, evaluator.num_klass)
        subjects = create_list(:subject, evaluator.num_klass)

        klasses.zip(subjects).each do |klass, subject|
          create(:teacher, user: user, klass: klass, subject: subject)
        end
      end
    end

    factory :user_student do
      transient do
        num_klass 2
      end

      association :user_group, factory: :user_group_student

      after(:create) do |user, evaluator|
        klasses = create_list(:klass, evaluator.num_klass)
        klasses.each do |klass|
          create(:student, user: user, klass: klass)
        end
      end
    end
  end
end
