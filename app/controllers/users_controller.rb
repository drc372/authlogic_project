class UsersController < ApplicationController

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
    @curURL = request.request_uri
    if(current_user) then
      @curUser = current_user.login
    else
      @curUser = nil
    end
    @match = "/users/#{@curUser}"

    @userlevel = UserLevel::OUTSIDER 
    if(@match.eql?(@curURL)) then
      @userlevel = UserLevel::USER
    elsif(@curUser != nil)
      @userlevel = UserLevel::FRIEND
    else
      @userlevel = UserLevel::OUTSIDER
    end
  end

  def index
  end

end
