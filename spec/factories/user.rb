FactoryGirl.define do
  factory :user do
    transient do
      num_credential 0
    end

    sequence(:name) { |n| "Edoardo #{n}" }
    surname 'Morassutto'
    user_group

    after(:create) do |user, evaluator|
      evaluator.num_credential.times do
        create(:credential, user: user)
      end
    end



    factory :user_admin do
      association :user_group, factory: :user_group_admin
    end

    factory :user_teacher do
      transient do
        num_klass 2
        with_klass nil
      end

      association :user_group, factory: :user_group_teacher

      after(:create) do |user, evaluator|
        klasses = create_list(:klass, evaluator.num_klass)
        subjects = create_list(:subject, evaluator.num_klass)

        klasses.zip(subjects).each do |klass, subject|
          create(:teacher, user: user, klass: klass, subject: subject)
        end

        if evaluator.with_klass
          create(:teacher, user: user, klass: evaluator.with_klass)
        end
      end
    end

    factory :user_student do
      transient do
        num_klass 2
        with_klass nil
      end

      association :user_group, factory: :user_group_student

      after(:create) do |user, evaluator|
        klasses = create_list(:klass, evaluator.num_klass)
        klasses.each do |klass|
          create(:student, user: user, klass: klass)
        end
        if evaluator.with_klass
          create(:student, user: user, klass: evaluator.with_klass)
        end
      end
    end
  end
end
