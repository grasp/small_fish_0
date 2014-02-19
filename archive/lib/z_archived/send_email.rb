require 'action_mailer'

class Notifier < ActionMailer::Base
  def email(mailto,subject,ebody)
    mail(:to=>mailto,:from=>"hunter.wxhu@gmail.com",:subject=> subject,:body=>ebody)
  end
end
 
Notifier.delivery_method = :smtp

Notifier.smtp_settings = {
  :address              => "smtp.gmail.com",  
  :port                 => 587,                 
  :user_name            => 'hunter.wxhu',      
  :password             => 'tianrenheyi123#',      
  :authentication       => 'plain',             
  :enable_starttls_auto => true
}



Notifier.email("hunter.wxhu@163.com","adfds","dafsdf").deliver