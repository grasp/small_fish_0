
require 'settingslogic'

class AppSettings < Settingslogic
  source File.expand_path('../config/hun_dun_1.yml', File.dirname(__FILE__))
end

if $0==__FILE__ 
   strage_name="hundun_1"
   puts AppSettings.send(strage_name).path
   puts AppSettings.stock_list_path
end