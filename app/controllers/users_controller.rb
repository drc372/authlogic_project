class UsersController < ApplicationController
  before_filter :determineUserLevel
  before_filter :require_no_user, :only => [:new,:resetpassword,:reset,:forgot]
  before_filter :require_user, :only => [:update]

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
     
    # Authlogic does not detect null passwords on update, this will check for it
    if ( (params[:commit] == 'Change Email') or (not params[:user][:password].blank?) )
      if @user.update_attributes(params[:user])
        flash[:notice] = "Successfully updated #{@changed}."
        redirect_to root_url
      elsif
        redirect_to "/users/#{@user.login}/edit", 
        :flash => { :notice => @user.errors }
      end
    elsif
      @user.errors[:base] = "Password field blank"
      redirect_to "/users/#{@user.login}/edit", 
        :flash => { :notice => @user.errors }
    end
  end

  
### Reset Password ###
  def forgot
    render :action => "users/forgot"
  end

  def resetcall
    username = params[:username]
    @user = User.find_by_login(username)
    if @user
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @perish_token = params[:token]    

      success = false

      if @user.perishable_token == @perish_token
        if @user.update_attributes(params[:user])
          success = true
        end
      end
    
      if success
        redirect_to "/users/#{params[:username]}",
        :flash => { :notice => "Successfully updated profile." }
      else
        redirect_to "/reset/#{params[:username]}/#{params[:token]}", 
        :flash => { :notice => @user.errors }
      end
    else
      redirect_to root_path
    end
  end

  def reset
    # First ensure the username and perishable token are valid
    @login = params[:login]
    @perish_token = params[:token]
    @user = User.find_by_login(@login)

    if (@user and @user.perishable_token == @perish_token) then
      render "users/reset" 
    else
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
        "If you are having issues try copying and pasting the URL " +  
        "from your email into your browser or restarting the " +  
        "reset password process."
      render "/users/resetFailure"
    end   
  end

  def resetpassword
    @login,@user,@email = nil
    @email = params[:user][:email]
    @login = params[:user][:login]

    if(!(@user = User.find_by_email(@email)))
      @user = User.find_by_login(@login)
    end

    if @user
      @user.send_password_reset_instructions
      flash[:notice] = "Instructions to reset your password have been emailed to you, #{@user.login}. " + "Please check your email, #{@user.email}."
      render :action => "home/emailconfirmation"
    else
      flash[:notice] = "Sorry the user could not be found."
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
