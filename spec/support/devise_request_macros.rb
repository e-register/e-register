module DeviseRequestMacros
  def sign_in(user = nil)
    cred = create(:credential, user: user, password: 'secret')
    #page.driver.post user_session_path, user: { username: cred.username, password: 'secret' }
    visit new_user_session_path
    fill_in 'Username', with: cred.username
    fill_in 'Password', with: 'secret'
    click_on 'Log in'
  end

  # checks if the response is a 'Not Authorized' in a request spec
  def check_unauthorized
    expect(current_path).to eq(root_path)
    expect(page).to have_content('You are not authorized to perform this action.')
  end
end

