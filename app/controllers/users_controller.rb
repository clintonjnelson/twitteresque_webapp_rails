class UsersController < ApplicationController
  # We can use whatever the before filter avails to us - IV's, etc. (See "edit")
  before_filter :signed_in_user,    only: [:edit, :update, :index,
                                           :followers, :following]
  before_filter :correct_user,      only: [:edit, :update]
  before_filter :admin_user,        only: [:destroy]
  before_filter :protect_newcreate, only: [:new, :create]

  ############# Creation Actions #############
  def new
    @user = User.new
  end

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


  ############# Individual User Actions #############
  def edit
    # @user = User.find(params[:id])    # Before_filter sets it for edit & update
  end

  def update
    # @user = User.find(params[:id])    # Before_filter sets it for edit & update
    if @user.update_attributes(params[:user])  # Returns true if successful
      flash[:success] = 'Profile Updated'
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    # Grab the user info per the passed :id, so we can use & display it as desired.
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def followers
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(page: (params[:page]))
      render "show_follow"
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: (params[:page]))
    render 'show_follow'
  end

  ############# ADMIN or All User Actions #############
  def index
      @users = User.paginate(page: params[:page])
  end

  def destroy
    @user = User.find(params[:id])

    if @user.admin?
      flash[:error] = "Admin Cannot Be Deleted"
    else
      @user.destroy
      flash[:success] = "User Deleted."
    end
      redirect_to users_path
  end

  private

    ## MOVED THIS TO THE SESSIONS HELPER TO ALLOW ACCESS FROM MICROPOSTS CONTROLLER TOO
    # def signed_in_user
    #   unless signed_in?
    #     store_location
    #     redirect_to signin_path, notice: "Please sign in."
    #   end
    #   # OLD: redirect_to signin_path, notice: "Please Sign In" unless signed_in?
    # end

    # Method to verify if the user is the same as current_user.
    # HOW DOES THIS VERIFY USERS AGAINST TRYING TO ACCESS OTHERS???
    # OH, BECAUSE THE PARAMS PASSED FOR AN EDIT ATTEMPT COULD BE ANOTHER"S...
    # SO checks attempted access user against the remember_token user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def protect_newcreate
      redirect_to root_path if signed_in?
    end
end
