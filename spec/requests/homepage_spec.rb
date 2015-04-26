require 'rails_helper'

describe 'Homepage', type: :request do
  context 'logged user' do
    let(:user) { create(:user) }
    before { sign_in(user) }

    it 'shows the user info' do
      visit root_path

      username = Credential.find_by(user: user).username

      expect(page).to have_content(user.full_name)
      expect(page).to have_content("(#{username})")
      expect(page).to have_button('Logout')
    end
  end

  context 'unlogged user' do
    it 'shows the login form' do
      visit root_url

      expect(page).to have_field('Username')
      expect(page).to have_field('Password')
      expect(page).to have_button('Log in')
    end
  end

  describe 'Header' do
    it 'should have the school information' do
      visit root_path

      expect(page).to have_content(APP_CONFIG['school']['full_name'])
      expect(page).to have_content(APP_CONFIG['school']['sub_name'])
    end
  end
end
