FactoryGirl.define do
  factory :presence do
    association :teacher, factory: :user_teacher
    student
    date Date.today
    hour 1
    association :presence_type, factory: :presence_type_absent
    note 'The student is absent'
  end
end
