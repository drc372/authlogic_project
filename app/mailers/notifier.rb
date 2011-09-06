class Notifier < ActionMailer::Base
  default :from => "dan@thecomedydumpster.com"
  
  def registration_confirmation(user)
    mail(:to => user.email, :subject => "Registered")
  end


  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    from          "Binary Logic Notifier "  
    recipients    user.email  
    sent_on       Time.now  
    #body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end  

end
