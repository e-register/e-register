Warden::Strategies.add(:multi_credential_login_strategy) do
  def valid?
    # the login can be performed if the username and the password are provided from parameters
    params[:user] && params[:user][:username] && params[:user][:password]
  end

  def authenticate!
    # fetch username and password from params
    username = params[:user][:username]
    password = params[:user][:password]

    # search the user form username
    credential = Credential.find_by(username: username)

    # check if the username exists and the password is correct
    return fail(:not_found_in_database) unless credential
    return fail(:invalid) unless credential.valid_password? password

    # store the username in the session of the user to be recovered later
    session[:username] = username

    # Yee! the login is successful
    success!(credential.user)
  end
end
