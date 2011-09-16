class User < ActiveRecord::Base
  acts_as_authentic

  def send_password_reset_instructions()
    reset_perishable_token!
    Notifier.reset_instructions(self).deliver
  end  

  def send_user_registration_congrats(host)
    #
    Notifier.registration_confirmation(self).deliver
  end  

end
