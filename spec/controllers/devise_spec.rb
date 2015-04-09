require 'rails_helper'

describe DeviseController, type: :controller do
  it 'stubs login with a real user' do
    user = create(:user)
    sign_in user

    expect(controller.current_user).to eq(user)
  end

  it 'stubs a fake login' do
    sign_in nil

    expect(controller.current_user).to be_nil
  end
end
