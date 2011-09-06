ActionMailer::Base.smtp_settings = 
{
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "thecomedydumpster.com",  
  :user_name            => "dan@thecomedydumpster.com",  
  :password             => "Toomp123",
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}  
