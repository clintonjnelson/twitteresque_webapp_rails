class SessionsController < ApplicationController
  # This creates a session of the user being logged in & is destroyed on logout.
  # This creation is like an on/off switch

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user  #Clever how this reads! Clear how the default works
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
