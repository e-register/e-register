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
        expect(page).to have_link("#{teach.klass.name} #{teach.subject.name}", href: evaluations_teacher_path(teach))
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

      check_unauthorized
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

      check_unauthorized
    end
  end

  describe 'EvaluationsController#create' do
    # TODO:
    #   This test is slower than the other tests all together
    #   This tests only a small part of the application
    #   This test bugs a lot the test suite, requires some glitches to work (not so clever :/)
    #   Refractor this test to a simpler Controller Spec
    it 'creates a new evaluation', js: true, slow: true do
      teacher = create(:teacher)
      student = create(:student, klass: teacher.klass)
      score = create(:score, as_string: '8+')
      # create(:evaluation_type_practical)
      type = create(:evaluation_type_oral)
      # create(:evaluation_type_written)

      sign_in create(:user_admin)

      visit new_evaluation_teacher_path(teacher)

      select student.user.full_name, from: 'Student'
      fill_in 'Date', with: '07/01/1997'

      # remove the datepicker from the screen
      page.execute_script('$("#ui-datepicker-div").remove();')

      page.find('#evaluation_score').trigger('focus')
      click_on score.as_string

      # remove the dialog from the screen
      page.execute_script('$("#score-dialog, .modal-backdrop").remove();')

      # for now this test is skipped because I can't find a valid way to do that :/
      #page.find(:css, "#evaluation_evaluation_type_id_#{type.id}").trigger('click')
      #page.choose("evaluation_evaluation_type_id_#{type.id}")

      page.find('#evaluation_visible').set(true)

      fill_in 'Description', with: 'Sample description'

      click_on 'Create'

      eval = Evaluation.first

      expect(eval).not_to be_nil
      expect(eval.teacher).to eq(teacher)
      expect(eval.student).to eq(student)
      expect(eval.date).to eq(Date.parse '07/01/1997')
      expect(eval.score).to eq(score)
      expect(eval.evaluation_type).to eq(type)
      expect(eval.visible).to be_truthy
      expect(eval.description).to eq('Sample description')
    end

    it 'blocks unauthorized users' do
      teacher = create(:teacher)
      sign_in create(:user_teacher)

      visit new_evaluation_teacher_path(teacher)

      check_unauthorized
    end
  end

  describe 'EvaluationsController#update' do
    it 'updates an evaluation' do
      evaluation = create(:evaluation)

      sign_in create(:user_admin)

      visit edit_evaluation_path(evaluation)

      fill_in 'Date', with: '07/01/1997'

      click_on 'Update'

      evaluation.reload

      expect(evaluation.date).to eq(Date.parse '07/01/1997')
    end

    it 'blocks unauthorized users' do
      eval = create(:evaluation)
      sign_in create(:user_teacher)

      visit edit_evaluation_path(eval)

      check_unauthorized
    end
  end

  describe 'EvaluationsController#destroy' do
    it 'destroys the evaluation' do
      evaluation = create(:evaluation)
      sign_in create(:user_admin)

      visit evaluation_path(evaluation)

      click_on 'Delete'

      expect(current_path).to eq(root_path)

      expect { evaluation.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'EvaluationsController#student' do
    it 'blocks unauthorized users' do
      student = create(:student)

      sign_in create(:user_student)

      visit evaluations_student_path(student)

      check_unauthorized
    end
  end
end
