FactoryGirl.define do
  factory :event do
    association :teacher, factory: :user_teacher
    klass
    date Date.today
    text 'A sample note'
    visible true

    factory :event_hidden do
      visible false
    end
  end
end
