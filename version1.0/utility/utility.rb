require 'action_mailer'
require 'settingslogic'

#require File.expand_path("../../utility/stock_init.rb",__FILE__)

 class Strategy < Settingslogic
      source File.expand_path('../strategy.yml',__FILE__)
 end

class Notifier < ActionMailer::Base
  def email(mailto,subject,ebody)
    mail(:to=>mailto,:from=>"hunter.hu@nsn.com",:subject=> subject,:body=>ebody)
  end
end

#reference 6.2 of http://guides.rubyonrails.org/action_mailer_basics.html
ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'w090.com',
  user_name:            'mark.xiansheng',
  password:             'tianrenheyi123#',
  authentication:       'plain',
  enable_starttls_auto: true  }

ActionMailer::Base.delivery_method = :smtp

result=`ipconfig`
if result.match("10.69.70.34")
    ENV['http_proxy']="http://10.140.19.49:808"
    ENV['https_proxy']="https://10.140.19.49:808"
end


module StockUtility

#发送email
def email_notify(strategy,title,body)
  Notifier.email(Strategy.send(strategy).email_receiver,title,body).deliver!
end


def convert_yahoo_symbol_to_sina(yahoo_symbol)
   sina_id=yahoo_symbol.split(".").reverse.join  if yahoo_symbol.match("sz")
   sina_id=yahoo_symbol.gsub("ss","sh").split(".").reverse.join  if yahoo_symbol.match("ss")
   return sina_id
end

end

if $0==__FILE__
  include StockUtility
  strategy="hundun_1"
  email_notify(strategy,"stock notify email: test","This is just a test of email")
end