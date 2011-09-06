class UsersController < ApplicationController
  before_filter :determineUserLevel

### User Accounts ###
  def index
  end

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

  
### Reset Password ###
  def forgot
    render :action => "users/forgot"
  end

  def test

  end

  def resetbyemail
    @email = params[:user][:email]
    @user = User.find_by_email(@email)
    if @user
      @user.send_password_reset_instructions
      #Notifier.registration_confirmation(@user).deliver
      flash[:notice] = "Instructions to reset your password have been emailed to you, #{@user.login}. " + "Please check your email, #{@user.email}."
      redirect_to :back  
    else  
      flash[:notice] = "No user with the email address \"#{@email}\" was found"  
      redirect_to :back  
    end
  end

  def resetbyusername
    @user = User.find_by_login(params[:login])
    if @user

    end
  end


### User Accounts ###
  def show
    # Look for a user with the vanity link

    # First get the user path you are looking for
    @userPage = request.fullpath.split("users/").split('/')[1][0]
    
    # This finds the user object and gets its name or returns nil
    if(! @tempUser = User.try(:find_by_login,@userPage).try(:login))
      #DanC Todo: Redirect this to 404 instead of this warning
      @tempUser = "Error!!! Can't find user.  Should redirect to 404"
    end
  end

### Determine User Level ###
  def determineUserLevel
    @curURL = request.fullpath

    if(current_user)
      @curUser = current_user.login
    else
      @curUser = nil
    end
    @match = "/users/#{@curUser}"
    @matchPath = @curURL[0...@match.length+1]

    if (@curUser == nil) then 
      @userlevel = UserLevel::PUBLIC 
    elsif(@match.eql?(@curURL) || @matchPath.eql?(@match+"/")) then
      @userlevel = UserLevel::USER
      @user = current_user
    else
      @userlevel = UserLevel::FRIEND
    end
  end


end
