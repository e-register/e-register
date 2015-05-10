require 'rails_helper'

describe EvaluationsController, type: :controller do
  describe 'GET /evaluations' do
    context 'as admin' do
      it 'renders the admin page' do
        teach1 = create(:teacher)
        teach2 = create(:teacher)
        teach3 = create(:teacher, klass: teach2.klass)

        user = create(:user_admin)
        sign_in user

        expected = {
            teach1.klass => [ teach1 ],
            teach2.klass => [ teach2, teach3 ]
        }

        get :index

        teachers = assigns(:teachers)

        teachers.each { |k,t| expect(t).to match_array(expected[k]) }
        expected.each { |k,t| expect(t).to match_array(teachers[k]) }

        expect(response).to render_template(:index_admin)
      end
    end

    context 'as student' do
      it 'renders the student page with more than one class' do
        user = create(:user_student, num_klass: 2)
        sign_in user

        get :index

        expect(response).to render_template(:index_student)
      end

      it 'redirects to the evaluation/class page with one class' do
        user = create(:user_student, num_klass: 1)
        sign_in user

        get :index

        expect(response).to redirect_to(evaluations_student_path(user.students.first))
      end
    end

    context 'as a teacher' do
      it 'renders the teacher page with more than one class' do
        user = create(:user_teacher, num_klass: 2)
        sign_in user

        get :index

        expect(response).to render_template(:index_teacher)
      end

      it 'redirects to the evaluation/class page with one class' do
        user = create(:user_teacher, num_klass: 1)
        sign_in user

        get :index

        expect(response).to redirect_to(evaluations_teacher_path(user.teachers.first))
      end
    end
  end

  describe 'GET /evaluations/teacher/:teacher_id/new' do
    it 'sets the instance variables correctly' do
      teacher = create(:teacher)
      score = create(:score)
      student = create(:student, klass: teacher.klass)
      type = create(:evaluation_type)

      sign_in teacher.user

      get :new, teacher_id: teacher.id

      expect(assigns(:teacher)).to eq(teacher)
      eval = assigns(:evaluation)
      expect(eval.teacher).to eq(teacher)
      expect(eval.date).to eq(Date.today)
      expect(eval.visible).to be_truthy
      expect(assigns(:scores)).to match_array([score])
      expect(assigns(:types)).to match_array([type])
      expect(assigns(:students)).to match_array([[student.user.full_name, student.id]])
    end
  end

  describe 'GET /evaluations/student/:student_id' do
    it 'sets the instance variables correctly' do
      stud = create(:student)
      eval1 = create(:evaluation, student: stud)
      eval2 = create(:evaluation, student: stud, teacher: eval1.teacher)
      eval3 = create(:evaluation, student: stud)

      sign_in stud.user

      get :student, student_id: stud.id

      expect(assigns(:student)).to eq(stud)

      expect(assigns(:evaluations)[eval1.teacher.subject]).to match_array [eval1, eval2]
      expect(assigns(:evaluations)[eval3.teacher.subject]).to match_array [eval3]

      expect(assigns(:types)).to match_array(EvaluationType.all)
      expect(assigns(:fluid)).to be_truthy
    end
  end

  describe 'GET /evaluations/teacher/:teacher_id' do
    it 'sets the instance variables correctly' do
      teacher = create(:teacher)

      stud1 = create(:student, klass: teacher.klass)
      stud2 = create(:student, klass: teacher.klass)

      written = create(:evaluation_type_written)
      oral = create(:evaluation_type_oral)
      practical = create(:evaluation_type_practical)

      klass_test = create(:klass_test, date: Date.today)

      eval1 = create(:evaluation, student: stud1, teacher: teacher, evaluation_type: written, date: Date.yesterday)
      eval2 = create(:evaluation, student: stud1, teacher: teacher, evaluation_type: written, klass_test: klass_test)
      eval3 = create(:evaluation, student: stud2, teacher: teacher, evaluation_type: written, klass_test: klass_test)
      eval4 = create(:evaluation, student: stud2, teacher: teacher, evaluation_type: written, date: Date.tomorrow)

      eval5 = create(:evaluation, student: stud1, teacher: teacher, evaluation_type: practical)
      eval6 = create(:evaluation, student: stud2, teacher: teacher, evaluation_type: practical)

      eval7 = create(:evaluation, student: stud1, teacher: teacher, evaluation_type: oral, date: Date.yesterday)
      eval8 = create(:evaluation, student: stud2, teacher: teacher, evaluation_type: oral, klass_test: create(:klass_test))
      eval9 = create(:evaluation, student: stud1, teacher: teacher, evaluation_type: oral, date: Date.tomorrow)

      sign_in teacher.user

      get :teacher, teacher_id: teacher.id

      expect(assigns(:teacher)).to eq(teacher)
      expect(assigns(:types)).to eq(EvaluationType.all)
      expect(assigns(:fluid)).to be_truthy
      expect(assigns(:students)).to match_array([stud1, stud2])

      expected_data = {
          written.id => {
              stud1.id => [eval1, eval2],
              stud2.id => [nil,   eval3, eval4]
          },
          practical.id => {
              stud1.id => [eval5],
              stud2.id => [eval6]
          },
          oral.id => {
              stud1.id => [eval7, nil,  eval9],
              stud2.id => [nil,   eval8]
          }
      }

      data = assigns(:data)

      [written, oral, practical].each do |type|
        [stud1, stud2].each do |stud|
          expect(data[stud.id][type.id]).to eq(expected_data[type.id][stud.id])
        end
      end
    end
  end
end
