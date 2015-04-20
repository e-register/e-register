require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET /user' do
    it 'assigns @user' do
      user = create(:user)
      sign_in user

      get :show

      expect(assigns(:user)).to eq(user)
    end
  end
end
