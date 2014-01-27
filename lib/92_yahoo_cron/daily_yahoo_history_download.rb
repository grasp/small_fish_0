require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/history_data/save_download_history_data_from_yahoo.rb",__FILE__)
require File.expand_path("../../8_utility/email_notify.rb",__FILE__)

def daily_history(strategy)

 init_strategy_name(strategy)
 today=Time.now.to_s[0..9].to_s

 #history_daily_data_3_folder=File.expand_path("history_daily_data3",$raw_data)
 puts $raw_data
 folder=File.expand_path("#{today}",$history_daily_3) 
 Dir.mkdir(folder) unless File.exists?(folder)

 raise unless File.exists?(folder)
  date=Time.now.to_s[0..9]
  #最好把这个diff day算出来，而不是一个固定的40
  download_all_symbol_into_history_data(folder,60)
  Notifier.email("hunter.wxhu@163.com;hunter.hu@nsn.com;hunter.wxhu@gmail.com","small_fish:#{today} yahoo history download done !","done!").deliver!

end

if $0==__FILE__
 strategy="hundun_1" 
 daily_history(strategy)
end