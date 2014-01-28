class UsersController < ApplicationController

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Your signup was successful - WELCOME to the sample app!"
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
