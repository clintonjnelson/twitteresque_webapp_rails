class MicropostsController < ApplicationController
  before_filter :signed_in_user   #default applies to all actions
  before_filter :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    # Praams[:micropost] carries in it the content to be fed
    # We want to user save to test for OK or return false, instead of create/create!
    if @micropost.save
      flash[:success] = 'Micropost Created'
      redirect_to root_path
    else
      @feed_items = []
      #flash[:error] = "Could not create micropost. Please check your micropost info."
      render 'static_pages/home'
    end
  end

  def destroy
    if current_user?(@micropost.user)
      @micropost.destroy
      flash[:success] = "Micropost Deleted"
    else
      flash[:error] = "Incorrect User Error. Contact Unlist Admin."
    end
    redirect_back_or root_path
  end

  private
    def correct_user
      @micropost = current_user.microposts.find(params[:id])
    # Instead of rescuing error, we could use find_by_id() above & it ignores errors
    rescue
      redirect_to root_path   # This says do something if error & ignore error
    end
end
