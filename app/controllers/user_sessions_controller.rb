class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful hey thats a good thing right?"
      redirect_back_or_default :root
    else
      redirect_back_or_default :root
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful if you come back you get more virgins than a dead muslim"
    redirect_back_or_default :root
  end

end
