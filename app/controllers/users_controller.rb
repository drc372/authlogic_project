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

  def resetcall
    @username = params[:username] 
    @user = User.find_by_login(@username)
    @perishable_token = params[:token]
    @user_token = @user.perishable_token
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @test = params[:user]
    @curURL = request.fullpath
    @success = false
 
    if @user.perishable_token == @perishable_token
      if @user.update_attributes(params[:user])
        flash[:notice] = "Successfully updated profile."
        @success = true
      else
        flash[:notice] = "Failed updating profile."
      end
    else
      flash[:notice] = "Invalid token sent #{@user_token} : #{@perishable_token}"
    end
    
    if @success
      redirect_to "#{params[:username]}"
      #redirect_to :action => "users/#{params[:username]}/"
    else
      render "users/reset"
      #redirect_to "/reset/#{params[:username]}/#{params[:token]}"
    end
  end

  def reset
    # First ensure the username and perishable token are valid
    @login = params[:login]
    @perish_token = params[:token]
    @user = User.find_by_login(@login)

    if @user.perishable_token == @perish_token
      flash[:notice] = "We're gonna reset you here"
      #DanC: Put password edit here
    else
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
        "If you are having issues try copying and pasting the URL " +  
        "from your email into your browser or restarting the " +  
        "reset password process."  
    end
    
    render "users/reset"    
  end

  def resetpassword
    @email,@login,@user = nil
    @used_login = false
    @email = params[:user][:email]
    @login = params[:user][:login]
    if(!(@user = User.find_by_email(@email)))
      @user = User.find_by_login(@login)
      @used_login = true
    end

    if @user
      @user.send_password_reset_instructions
      flash[:notice] = "Instructions to reset your password have been emailed to you, #{@user.login}. " + "Please check your email, #{@user.email}."
      render :action => "home/emailconfirmation"
    else
      if @used_login
        flash[:notice] = "Sorry the Username supplied could not be found."
      else
        flash[:notice] = "Sorry the email supplied could not be found."
      end
      redirect_to :back
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
