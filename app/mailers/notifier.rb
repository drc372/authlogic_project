class Notifier < ActionMailer::Base
  default :from => "dan@thecomedydumpster.com"

### User Registration ###
  def activation_instructions(user)
    @user = user
    @host = "http://localhost:3000"
    @url = "#{@host}/activate/#{user.login}/#{user.perishable_token}"
    mail(:to => user.email, 
         :subject => "Activation Instructions")
  end


### Password Reset ###
  def reset_instructions(user)
    @user = user
    @host = "http://localhost:3000"
    @url = "#{@host}/reset/#{user.login}/#{user.perishable_token}"
    mail(:to => user.email, 
         :subject => "Password Reset Instructions")
  end  

end
