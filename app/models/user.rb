class User < ActiveRecord::Base
  acts_as_authentic

  def send_password_reset_instructions
    reset_perishable_token!
    #Notifier.deliver_password_reset_instructions(self).deliver
    Notifier.registration_confirmation(self).deliver
  end  

end
