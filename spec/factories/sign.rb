FactoryGirl.define do
  factory :sign do
    association :teacher, factory: :user
    association(:subject, factory: :subject) { teacher.teachers.first.subject }
    association(:klass, factory: :klass) { teacher.teachers.first.klass }
    date Date.today
    hour 1
    lesson 'Limits and Differential'
  end
end
