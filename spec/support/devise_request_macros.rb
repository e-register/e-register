module DeviseRequestMacros
  def sign_in(user = nil)
    login_as(user, scope: :user)
  end
end

