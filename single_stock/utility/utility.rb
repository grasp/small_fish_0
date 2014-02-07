require 'action_mailer'
require 'settingslogic'

require File.expand_path("../../utility/stock_init.rb",__FILE__)

 class Strategy < Settingslogic
      source File.expand_path('../strategy.yml',__FILE__)
 end

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

module StockUtility

#发送email
def sent_email(address,title,body)
	Notifier.email(address,title,body).deliver!
end


def convert_yahoo_symbol_to_sina(yahoo_symbol)
   sina_id=yahoo_symbol.split(".").reverse.join  if yahoo_symbol.match("sz")
   sina_id=yahoo_symbol.gsub("ss","sh").split(".").reverse.join  if yahoo_symbol.match("ss")
   return sina_id
end

end