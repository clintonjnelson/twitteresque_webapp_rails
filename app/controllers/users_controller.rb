class UsersController < ApplicationController

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Your signup was successful - Welcome to the sample app!"
      sign_in @user   # Loads user's :remember_token into cookies on browser
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
    @user = User.new
  end

  def show
    # Grab the user info per the passed :id, so we can use & display it as desired.
    @user = User.find(params[:id])
  end

end
