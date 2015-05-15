require 'rails_helper'

describe PresencesController, type: :controller do
  describe 'GET /classes/:klass_id/presences/:id' do
    it 'fetches the presence correctly' do
      presence = create(:presence, date: Date.today)

      sign_in create(:user_admin)

      get :show, klass_id: presence.student.klass_id, id: presence.id

      expect(assigns(:presence)).to eq(presence)
      expect(assigns(:today_presences)).to match_array([presence])
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
end
