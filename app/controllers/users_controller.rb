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
    #@user = User.find(params[:id])
    @user = User.find_by_login(params[:login])
    @curcur = current_user.login
    @loginvar = params[:login]

    @test = false
    if(@user == current_user) then
      @test = true
    end
  end

  def index
  end

end
