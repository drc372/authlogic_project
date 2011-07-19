class UsersController < ApplicationController
  before_filter :determineUserLevel

  def new
    @title = "Sign Up!"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render :action => 'edit'
    end

  end


  def show

  end

  def index
  end

  def determineUserLevel
    @curURL = request.fullpath

    if(current_user) then
      @curUser = current_user.login
    else
      @curUser = nil
    end
    @match = "/users/#{@curUser}"
    @matchLength = @match.length
    @trunkedURL = @curURL[0...@matchLength]

    if (@curUser == nil)
      @userlevel = UserLevel::PUBLIC 
    elsif(@match.eql?(@trunkedURL)) then
      @userlevel = UserLevel::USER
      @user = current_user
    else
      @userlevel = UserLevel::FRIEND
    end

  end

end
