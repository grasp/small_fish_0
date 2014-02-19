require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/sina/sina_history.rb",__FILE__)
require File.expand_path("../../20_data_process/append_data.rb",__FILE__)
require File.expand_path("../../30_signal_gen/append_signal.rb",__FILE__)
require File.expand_path("../../0_common/common.rb",__FILE__)
require File.expand_path("../../22_data_validate/validate_daily_data.rb",__FILE__)
require File.expand_path("../../8_utility/expected_working_day.rb",__FILE__)
require File.expand_path("../../8_utility/email_notify.rb",__FILE__)

 strategy="hundun_1"
 init_strategy_name(strategy)

today=Time.now.to_s[0..9]

#这里读取期望的最近日线数据的日期
expected_working_day=get_expected_working_date(2014,today)

#从已经更新的日线数据中获取上次最新的下载日期
last_date1=get_last_date_on_daily_k("000009.sz").to_s
last_date2=get_last_date_on_daily_k("000008.sz").to_s

last_date1>=last_date2 ? last_date=last_date1 : last_date=last_date2#总是取比较大的，比较小的可能因为停盘

#如果已经是最新了， 那么不需要做任何下载的动作
 if expected_working_day==last_date
 	$logger.info("expected_working_day==last_date=#{last_date}, exit with 0, already download latest" )
    return 0
 end

 #如果已经下载了，那么也不需要下载了
 target_file=File.expand_path("#{expected_working_day}.txt",$daily_data)
 if File.exists?(target_file)
  return 0 if validate_daily_date(expected_working_day)==true #如果已经下载了，并且验证通过，那就不需要下载了
 end

 if (not File.exists?(target_file)) && (Time.now.hour<7 || Time.now.hour>=15 || Time.now.sunday? || Time.now.saturday?)
 puts "start of download history"
 download_all_history_on_day("expected_working_day")
end

puts "end of download history"