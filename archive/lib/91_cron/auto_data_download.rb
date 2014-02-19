require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/history_data/save_download_history_data_from_yahoo.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/save_daily_data_into_one_text.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/append_daily_data_to_history.rb",__FILE__)
require File.expand_path("../../20_data_process/append_data.rb",__FILE__)
require File.expand_path("../../30_signal_gen/append_signal.rb",__FILE__)
require File.expand_path("../../0_common/common.rb",__FILE__)
require File.expand_path("../../22_data_validate/validate_daily_data.rb",__FILE__)

def aoto_daily_download(strategy)
    
#获取上次最新的下载日期
last_date1=get_last_date_on_daily_k("000009.sz").to_s
last_date2=get_last_date_on_daily_k("000008.sz").to_s

last_date1>=last_date2 ? last_date=last_date1 : last_date=last_date2#总是取比较大的，比较小的可能因为停盘

today=Time.now.to_s[0..9]

#检查diff day 是否大于1天
diff_day=get_diff_day(today,last_date1)
puts diff_day

#大于1天，首先下载yahoo历史数据

#在一天范围内，下载新浪数据

end

if $0==__FILE__
	strategy="hundun_1"
	init_strategy_name(strategy)
	aoto_daily_download(strategy)
end