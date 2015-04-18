FactoryGirl.define do
  factory :note do
    association :teacher, factory: :user_teacher
    association :notable, factory: :user_student
    date Date.today
    visible true
    text "He's behaviour is intolerable"
  end
end
