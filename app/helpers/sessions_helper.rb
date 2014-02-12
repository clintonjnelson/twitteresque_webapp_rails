module SessionsHelper

  # Method that sets browser cookie to the db value for permanent signin reference
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  # Setter method for @current_user IV
  def current_user=(user)
    @current_user = user
  end

  # This creates the appearance of persistence for a signed-in user
  def current_user
    # Note the ||= saves program from hitting db if there's already a value
    @current_user = User.find_by_remember_token(cookies[:remember_token])
  end

  # Helper to check if user is signed in or not (ie: cookies has remember_token)
  def signed_in?
    !current_user.nil?
  end
end
