require 'rails_helper'

describe PresencesController, type: :controller do
  describe 'GET /classes/:klass_id/presences' do
    it 'sets the instance varibles correctly' do
      klass = create(:klass)

      stud1 = create(:student, klass: klass)
      stud2 = create(:student, klass: klass)

      pres1 = create(:presence, student: stud1, date: Date.today)
      pres2 = create(:presence, student: stud1, date: Date.tomorrow)
      pres3 = create(:presence, student: stud2, date: Date.today)

      sign_in create(:user_admin)

      get :index, klass_id: klass

      expect(assigns(:klass)).to eq(klass)
      expect(assigns(:date)).to eq(Date.today)
      expect(assigns(:students)).to match_array [stud1, stud2]
      expect(assigns(:presences)).to eq({ stud1.id => [pres1], stud2.id => [pres3] })
    end

    it 'fetches the presence of the correct day' do
      klass = create(:klass)

      stud1 = create(:student, klass: klass)
      stud2 = create(:student, klass: klass)

      pres1 = create(:presence, student: stud1, date: Date.today)
      pres2 = create(:presence, student: stud1, date: Date.tomorrow)
      pres3 = create(:presence, student: stud2, date: Date.today)

      sign_in create(:user_admin)

      get :index, klass_id: klass, date: Date.tomorrow
      expect(assigns(:students)).to match_array [stud1, stud2]
      expect(assigns(:presences)).to eq({ stud1.id => [pres2] })
    end
  end

  describe 'GET /classes/:klass_id/presences/:id' do
    it 'fetches the presence correctly' do
      presence = create(:presence, date: Date.today)

      sign_in create(:user_admin)

      get :show, klass_id: presence.student.klass_id, id: presence.id

      expect(assigns(:presence)).to eq(presence)
    end

    it 'throws an error if the presence is missing' do
      sign_in create(:user_admin)

      get :show, klass_id: 123, id: 1234

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).not_to be_empty
    end

    it 'throws an error if the presence isn\'t in the right klass' do
      presence = create(:presence)

      sign_in create(:user_admin)

      get :show, klass_id: presence.student.klass_id+42, id: presence.id

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).not_to be_empty
    end
  end

  describe 'GET /classes/:klass_id/presences/new' do
    it 'sets the instance variables correctly' do
      klass = create(:klass)
      type = create(:presence_type)

      sign_in user = create(:user_admin)
      get :new, klass_id: klass.id

      expect(assigns(:klass)).to eq(klass)
      expect(assigns(:students)).to eq(klass.students.map { |s| [s.full_name, s.id] })
      expect(assigns(:presence_types)).to match_array([type])
      presence = assigns(:presence)
      expect(presence.klass).to eq(klass)
      expect(presence.teacher).to eq(user)
      expect(presence.date).to eq(Date.today)
      expect(presence.hour).to eq(1)
      expect(presence.presence_type_id).to eq(type.id)
    end
  end

  describe 'POST /classes/:klass_id/presences' do
    it 'creates the presence' do
      klass = create(:klass)
      type = create(:presence_type)
      student = create(:student, klass: klass)
      teacher = create(:teacher, klass: klass)
      sign_in teacher.user

      params = {
          klass_id: klass.id,
          presence: {
            student_id: student.id,
            date: Date.today,
            hour: 7,
            presence_type_id: type.id,
            note: 'FooBar'
          }
      }

      post :create, params

      presence = Presence.first

      expect(presence).not_to be_nil
      expect(presence.teacher).to eq(teacher.user)
      expect(presence.student).to eq(student)
      expect(presence.date).to eq(Date.today)
      expect(presence.hour).to eq(7)
      expect(presence.presence_type).to eq(type)
      expect(presence.note).to eq('FooBar')
    end

    it 'redirects to the correct url if an error' do
      klass = create(:klass)
      type = create(:presence_type)
      student = create(:student, klass: klass)
      teacher = create(:teacher, klass: klass)
      sign_in teacher.user

      params = {
          klass_id: klass.id,
          presence: {
              student_id: student.id,
              presence_type_id: type.id,
              note: 'FooBar'
          }
      }

      post :create, params

      expect(response).to redirect_to new_klass_presence_path(klass)
    end

    it 'redirects to the root if the student is missing' do
      klass = create(:klass)
      type = create(:presence_type)
      teacher = create(:teacher, klass: klass)
      sign_in teacher.user

      params = {
          klass_id: klass.id,
          presence: {
              presence_type_id: type.id,
              note: 'FooBar'
          }
      }

      post :create, params

      expect(response).to redirect_to root_path
    end
  end

  describe 'GET /classes/:klass_id/presences/:id/edit' do
    it 'sets the instance variables correctly' do
      klass = create(:klass)
      teacher = create(:teacher, klass: klass)
      student = create(:student, klass: klass)
      presence = create(:presence, student: student, teacher: teacher.user)

      sign_in teacher.user

      get :edit, klass_id: klass.id, id: presence.id

      expect(assigns(:klass)).to eq(klass)
      expect(assigns(:presence)).to eq(presence)
      expect(assigns(:students)).to match_array [[student.user.full_name, student.id]]
      expect(assigns(:presence_types)).to match_array [presence.presence_type]
    end
  end

  describe 'PATCH /classes/:klass_id/presences/:id' do
    it 'updates the presence correctly' do
      klass = create(:klass)
      teacher = create(:teacher, klass: klass)
      student = create(:student, klass: klass)
      presence = create(:presence, student: student, teacher: teacher.user)

      sign_in teacher.user

      new_student = create(:student, klass: klass)
      new_persence_type = create(:presence_type)

      params = {
        klass_id: klass.id,
        id: presence.id,
        presence: {
          student_id: new_student.id,
          date: Date.tomorrow,
          hour: 42,
          presence_type_id: new_persence_type.id,
          note: 'FooBar'
        }
      }

      post :update, params

      presence.reload

      expect(presence.student).to eq(new_student)
      expect(presence.date).to eq(Date.tomorrow)
      expect(presence.hour).to eq(42)
      expect(presence.presence_type).to eq(new_persence_type)
      expect(presence.note).to eq('FooBar')

      expect(response).to redirect_to klass_presence_path(new_student.klass, presence)
    end

    it 'redirects to the correct url if an error' do
      klass = create(:klass)
      teacher = create(:teacher, klass: klass)
      student = create(:student, klass: klass)
      presence = create(:presence, student: student, teacher: teacher.user)

      sign_in teacher.user

      params = {
        klass_id: klass.id,
        id: presence.id,
        presence: {
          hour: nil,
        }
      }

      post :update, params

      expect(response).to redirect_to edit_klass_presence_path(klass, presence)
    end

    it 'doesn\'t save if there is an authorization error' do
      klass = create(:klass)
      teacher = create(:teacher, klass: klass)
      student = create(:student, klass: klass)
      presence = create(:presence, student: student, teacher: teacher.user)

      sign_in teacher.user

      new_student = create(:student)
      new_persence_type = create(:presence_type)

      params = {
        klass_id: klass.id,
        id: presence.id,
        presence: {
          student_id: new_student.id
        }
      }

      post :update, params

      presence.reload

      expect(presence.student).to eq(student)
    end
  end

  describe 'DELETE /classes/:klass_id/presences/:id' do
    it 'deletes the presence' do
      presence = create(:presence)

      sign_in create(:user_admin)

      delete :destroy, klass_id: presence.student.klass_id, id: presence.id

      expect(response).to redirect_to root_path
      expect(flash[:notice]).to include 'deleted'
      expect(flash[:alert]).to be_nil
      expect { presence.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'doesn\'t delete the presence if unauthorized' do
      presence = create(:presence)

      sign_in create(:user_teacher)

      delete :destroy, klass_id: presence.student.klass_id, id: presence.id

      expect { presence.reload }.not_to raise_error

      expect(response).to redirect_to root_path
      expect(flash[:alert]).not_to be_nil
    end

    it 'doesn\'t delete the presence if an error' do
      presence = create(:presence)

      sign_in create(:user_admin)

      allow_any_instance_of(Presence).to receive(:destroy).and_return(false)

      delete :destroy, klass_id: presence.student.klass_id, id: presence.id

      expect { presence.reload }.not_to raise_error

      expect(response).to redirect_to klass_presence_path(presence.student.klass_id, presence)
      expect(flash[:alert]).not_to be_nil
    end
  end

  describe 'presence_params' do
    let(:presence) { create(:presence) }

    it 'removes justification_id on 0' do
      params = { justification_id: '0' }
      PresenceParams.send(:insert_justification, params, presence)

      expect(params[:justification_id]).to be_nil
    end
    it 'removes justification_id on -1' do
      params = { justification_id: '-1' }
      PresenceParams.send(:insert_justification, params, presence)

      expect(params[:justification_id]).to be_nil
    end
    it 'doesn\'t remove justification_id on 1' do
      params = { justification_id: '1' }
      PresenceParams.send(:insert_justification, params, presence)

      expect(params[:justification_id]).to eq('1')
    end

    it 'removes justified_at on justification_id == 0' do
      params = { justification_id: '0', justified_at: Date.yesterday }
      PresenceParams.send(:insert_justification, params, presence)

      expect(params[:justified_at]).to be_nil
    end
    it 'doesn\'t remove justified_at on justification_id != 0' do
      params = { justification_id: '1' }
      PresenceParams.send(:insert_justification, params, presence)

      expect(params[:justified_at]).to eq Date.today
    end
    it 'keeps the old justified_at' do
      presence.update! justified_at: Date.yesterday

      params = { justification_id: '1' }
      PresenceParams.send(:insert_justification, params, presence)

      expect(params[:justified_at]).to eq Date.yesterday
    end
  end
end
