require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/save_daily_data_into_one_text.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/append_daily_data_to_history.rb",__FILE__)
require File.expand_path("../../20_data_process/append_data.rb",__FILE__)
require File.expand_path("../../30_signal_gen/append_signal.rb",__FILE__)
require File.expand_path("../../0_common/common.rb",__FILE__)
require File.expand_path("../../22_data_validate/validate_daily_data.rb",__FILE__)
require File.expand_path("../../8_utility/expected_working_day.rb",__FILE__)
require File.expand_path("../../8_utility/email_notify.rb",__FILE__)

#today=Time.now.to_s[0..9]

  strategy="hundun_1"

init_strategy_name(strategy)

#这里读取期望的最近日线数据的日期
expected_working_day=get_expected_working_date(2014,"2014-01-27")


target_file=File.expand_path("#{expected_working_day}.txt",$daily_data)


# 最后的检查
valid_daily=validate_daily_date(expected_working_day) if File.exists?(target_file)
puts "valid_daily=#{valid_daily},expected_working_day=#{expected_working_day}"

if valid_daily==false
  File.delete(target_file)
	$logger.info("try 4 times download daily data, failed!!,return -1  ")
  # 此处需要增加邮件通知或者email通知失败
return -1  
#end
#end

puts "valid_daily=#{valid_daily}"
if valid_daily==true && File.exists?(target_file)# && (diff_day==max_diff_day) && (today > last_date) #&& (not Time.now.sunday?) && (not Time.now.saturday?)
  puts "start append #{target_file}"
  result= append_daily_data_into_history(expected_working_day)
 
  if result==0
  	begin
      append_all_data_process
      append_all_signal
      Notifier.email("hunter.wxhu@163.com;hunter.hu@nsn.com;hunter.wxhu@gmail.com","small_fish:#{expected_working_day}  append sina daily download succ !","done!").deliver!
    rescue Exception
	    $logger.info("#{$@}.split(",")}")
    end
  end
else
	 Notifier.email("hunter.wxhu@163.com;hunter.hu@nsn.com;hunter.wxhu@gmail.com","small_fish:#{expected_working_day}  append sina daily download fail !","done!").deliver!
end
end
