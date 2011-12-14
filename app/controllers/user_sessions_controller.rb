class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  #generalize_credentials_error_messages true

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful hey thats a good thing right?"
      redirect_to root_url
    else
      redirect_to "/login/error"
    end
    
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful, come back and you get more virgins than a dead muslim"
    #redirect_back_or_default :root
    redirect_to root_url
  end

end
