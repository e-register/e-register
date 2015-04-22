module DeviseRequestMacros
  def sign_in(user = nil)
    cred = create(:credential, user: user, password: 'secret')
    page.driver.post user_session_path, user: { username: cred.username, password: 'secret' }
  end
end

