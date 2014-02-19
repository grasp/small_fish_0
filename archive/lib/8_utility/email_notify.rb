require 'action_mailer'

class Notifier < ActionMailer::Base
  def email(mailto,subject,ebody)
    mail(:to=>mailto,:from=>"hunter.hu@nsn.com",:subject=> subject,:body=>ebody)
  end
end
 
ActionMailer::Base.smtp_settings = {
  :user_name => "w090.mark",
  :password => "999317",
  :domain => "w090.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

ActionMailer::Base.delivery_method = :smtp


def sent_email(address,title,body)
	
end

Notifier.email("hunter.wxhu@163.com;hunter.hu@nsn.com;hunter.wxhu@gmail.com","adfds","dafsdf").deliver!