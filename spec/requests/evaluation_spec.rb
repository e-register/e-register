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

  describe 'EvaluationsController#show' do
    it 'shows the evaluation information' do
      admin = create(:user_admin)
      eval = create(:evaluation)

      sign_in admin

      visit evaluation_path(eval)

      expect(page).to have_content(eval.teacher.user.full_name)
      expect(page).to have_content(eval.teacher.user.full_name)
      expect(page).to have_content(eval.student.user.full_name)
      expect(page).to have_content(eval.teacher.subject.name)
      expect(page).to have_content(eval.date)
      expect(page).to have_content(eval.score.as_string)
      expect(page).not_to have_content('?')
      expect(page).to have_content("#{eval.score_points} / #{eval.total_score}")
      expect(page).to have_content(eval.description)
    end

    it 'shows a ? if the score is nil' do
      admin = create(:user_admin)
      eval = create(:evaluation, score: nil)

      sign_in admin

      visit evaluation_path(eval)

      expect(page).to have_content('?')
    end

    it 'doesn\'t show the evaluation if non-admin' do
      eval = create(:evaluation)

      sign_in create(:user)

      visit evaluation_path(eval)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are not authorized to perform this action.')
    end
  end
end
