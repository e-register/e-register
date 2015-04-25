require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET /user' do
    it 'assigns views variables' do
      user = create(:user)
      sign_in user

      get :show

      expect(assigns(:user)).to eq(user)
      expect(assigns(:klasses)).to eq(user.klasses)
    end

    it 'throws exception to unlogged user' do
      get :show

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).not_to be_empty
    end
  end
end
