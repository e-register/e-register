require 'rails_helper'

describe 'Evaluation', type: :request do
  describe 'EvaluationsController#index' do
    it 'shows the list of classes for students' do
      user = create(:user_student)
      sign_in user

      visit evaluations_path

      expect(page).to have_content('Your classes')
      user.students.each do |stud|
        expect(page).to have_link(stud.klass.name, href: evaluations_student_path(stud))
      end
    end

    it 'shows the list of classes for teachers' do
      user = create(:user_teacher)
      sign_in user

      visit evaluations_path

      expect(page).to have_content('Your classes')
      user.teachers.each do |teach|
        expect(page).to have_link(teach.klass.name + ' - ' + teach.subject.name, href: evaluations_teacher_path(teach))
      end
    end
  end
end
