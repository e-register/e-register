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
      expect(page).to have_content(format_date eval.date)
      expect(page).to have_content(eval.score.as_string)
      expect(page).not_to have_content('?')
      expect(page).to have_content("#{eval.score_points} / #{eval.total_score}")
      expect(page).to have_content(eval.evaluation_type.name)
      expect(page).to have_content(yesno eval.visible)
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

  describe 'EvaluationsController#new' do
    it 'shows the new page for admins' do
      admin = create(:user_admin)
      teacher = create(:teacher)
      student = create(:student, klass: teacher.klass)
      score = create(:score)
      create(:evaluation_type_written)

      sign_in admin

      visit new_evaluation_teacher_path(teacher)

      expect(page).to have_field 'Student'
      expect(page).to have_content student.user.full_name

      expect(page).to have_field 'Date'
      expect(page).to have_field 'Score'
      expect(page).to have_field 'Description'

      expect(page).to have_content score.as_string

      expect(page).to have_field 'Written'
      expect(page).to have_field 'Visible'

      expect(page).to have_button 'Create'
    end

    it 'doesn\'t show the page for non-authorized' do
      teacher = create(:teacher)

      sign_in create(:user_teacher)

      visit new_evaluation_teacher_path(teacher)

      expect(current_path).to eq(root_path)
      expect(page).to have_content('You are not authorized to perform this action.')
    end
  end

  describe 'EvaluationsController#create' do
    it 'creates a new evaluation', js: true, slow: true do
      teacher = create(:teacher)
      student = create(:student, klass: teacher.klass)
      score = create(:score, as_string: '8+')
      type = create(:evaluation_type_oral)

      sign_in create(:user_admin)

      visit new_evaluation_teacher_path(teacher)

      select student.user.full_name, from: 'Student'
      fill_in 'Date', with: '07/01/1997'

      find('#evaluation_score').trigger('focus')

      click_on score.as_string

      fill_in 'Description', with: 'Sample description'

      click_on 'Create'

      eval = Evaluation.first

      expect(eval).not_to be_nil
      expect(eval.teacher).to eq(teacher)
      expect(eval.student).to eq(student)
      expect(eval.date).to eq(Date.parse '07/01/1997')
      expect(eval.score).to eq(score)
      expect(eval.evaluation_type).to eq(type)
      expect(eval.description).to eq('Sample description')
    end
  end
end
