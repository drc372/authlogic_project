class Notifier < ActionMailer::Base
  default :from => "dan@thecomedydumpster.com"

  def registration_confirmation(user)
    @user = user
    @host = "http://localhost:3000"
    @url = "#{@host}/reset/#{user.login}/#{user.perishable_token}"
    mail(:to => user.email, 
         :subject => "Registered")
  end


  def reset_instructions(user)
    @user = user
    @host = "http://localhost:3000"
    @url = "#{@host}/reset/#{user.login}/#{user.perishable_token}"
    mail(:to => user.email, 
         :subject => "Password Reset Instructions")
  end  

end
