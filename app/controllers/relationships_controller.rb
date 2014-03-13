class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    # Makes a new followed user for current_user
    @user = User.find(params[:relationship] [:followed_id])
    current_user.follow!(@user)

    # Listen for html(POST) or Ajax(XHR):
    respond_to do |format|
      format.html { redirect_to @user }
      format.js    # Ajax sees & looks for create.js.erb
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)

    # Listen for html(DELETE) or Ajax(XHR):
    respond_to do |format|
      format.html { redirect_to @user }
      format.js   # Ajax sees & looks for destroy.js.erb
    end
  end
end
