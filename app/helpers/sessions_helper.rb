module SessionsHelper
# HELPER IS SHARED THROUGH ALL CONTROLLERS THROUGH APPLICATION_CONTROLLER INCLUDE

  # Method that sets browser cookie to the db value for permanent signin reference
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # Helper to check if user is signed in or not (ie: cookies has remember_token)
  def signed_in?
    !current_user.nil?
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
    # OLD: redirect_to signin_path, notice: "Please Sign In" unless signed_in?
  end

  # Stores the page the user was just at before redirecting elsewhere. See
  def store_location
    session[:return_to] = request.fullpath
  end

  # Helper to redirect people back to the page they tried to get before signin stopped
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)    # CAN THIS HANDLE A NIL METHOD??????
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

  def current_user?(user)
    user == current_user
  end
end
