require 'rails_helper'

describe ApplicationController, type: :controller do
  it 'blocks unauthorized requests' do
    def controller.home
      raise Pundit::NotAuthorizedError
    end

    get :home

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).not_to be_empty
  end

  it 'shows unauthorized when not found' do
    def controller.home
      raise ActiveRecord::RecordNotFound
    end

    get :home

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).not_to be_empty
  end

  it 'returns the correct username' do
    session[:username] = 'foobar'

    expect(controller.current_user_username).to eq('foobar')
  end

  describe 'GET /' do
    it 'doesn\'t set @home_blocks' do
      get :home

      expect(assigns(:home_blocks)).to be_nil
    end

    def self.check_home_blocks_for_user(factory, user_type)
      it "sets @home_blocks for a #{user_type}" do
        user = create(factory)
        sign_in user

        get :home

        blocks = APP_CONFIG['homepage'][user_type]

        expect(assigns(:home_blocks)).to match_array(blocks)
      end
    end

    check_home_blocks_for_user(:user_student, 'student')
    check_home_blocks_for_user(:user_teacher, 'teacher')
    check_home_blocks_for_user(:user_admin, 'admin')

  end
end
