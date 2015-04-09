require 'rails_helper'

describe 'Authentication', type: :request do
  # Process the login through the entire login form
  def login_with(username, password)
    visit new_user_session_path

    fill_in 'Username', with: username
    fill_in 'Password', with: password

    click_button 'Log in'
  end

  describe 'GET /users/sign_in' do
    it 'shows the login form' do
      visit new_user_session_path
      expect(page).to have_content('Log in')

      expect(page).to have_content('Username')
      expect(page).to have_content('Password')

      expect(page).to have_field('Username')
      expect(page).to have_field('Password')
    end

    it 'logs in with correct credentials' do
      cred = create(:credential, password: 'secret')

      login_with(cred.username, 'secret')

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Signed in successfully.')
    end

    it 'does not logs in with incorrect credentials' do
      cred = create(:credential, password: 'secret')

      login_with(cred.username, 'incorrect')

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('Invalid username or password.')
    end

    it 'does not allow to users to login again' do
      sign_in create(:user)

      visit new_user_session_path

      expect(current_path).to eq(root_path)
    end
  end
end
