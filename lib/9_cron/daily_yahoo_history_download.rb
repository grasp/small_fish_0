require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/history_data/save_download_history_data_from_yahoo.rb",__FILE__)

def daily_history
 today=Time.now.to_s[0..9]
 folder=File.expand_path("./history_daily_data_3/#{today}","#{AppSettings.resource_path}")

if (not Time.now.saturday?) && (not Time.now.sunday?)      #=> returns a boolean value
 unless File.exists?(folder)
 	Dir.mkdir(folder)
 end

  date=Time.now.to_s[0..9]
  download_all_symbol_into_history_data("./history_daily_data_3/#{today}",30)
end

end

if $0==__FILE__
daily_history
end