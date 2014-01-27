require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/save_daily_data_into_one_text.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/append_daily_data_to_history.rb",__FILE__)
require File.expand_path("../../20_data_process/append_data.rb",__FILE__)
require File.expand_path("../../30_signal_gen/append_signal.rb",__FILE__)
require File.expand_path("../../0_common/common.rb",__FILE__)
require File.expand_path("../../22_data_validate/validate_daily_data.rb",__FILE__)
require File.expand_path("../../8_utility/expected_working_day.rb",__FILE__)
require File.expand_path("../../8_utility/email_notify.rb",__FILE__)

#需要对其这几个文件的最后一行的日期才可以做以下的操作，需要做更多的健壮性代码

#该函数只负责下载当下最新的日线数据，也不附加到原始信号，并有防止重复下载功能

def daily_append(strategy)
init_strategy_name(strategy)
$logger.info("start run daily append on #{Time.now}" )
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

#下面开始下载
################

#删除文件，如果文件无效
valid_daily=validate_daily_date(today) if File.exists?(target_file)

if valid_daily==false
  File.delete(target_file)
  $logger.info("delete the invalid daily data file , and try download again") 
end

#如果还没下载，或者下载文件有问题，准备再重新下载
if (not File.exists?(target_file)) && (Time.now.hour<7 || Time.now.hour>15 || Time.now.sunday? || Time.now.saturday?)

save_today_daily_data #此处下载日线数据到一个文件

#最多重复下载四次
3.downto(0).each do |i|
valid_daily=validate_daily_date(today) if File.exists?(target_file)

if valid_daily==false
  File.delete(target_file)
  $logger.info("daily download cycle #{i},valid_daily==false")
  sleep 200
  #try download again
  save_today_daily_data  
else
	break 
end

end

# 最后的检查
valid_daily=validate_daily_date(expected_working_day) if File.exists?(target_file)

if valid_daily==false
  File.delete(target_file)
	$logger.info("try 4 times download daily data, failed!!,return -1  ")
  # 此处需要增加邮件通知或者email通知失败
return -1  
end
#end


if valid_daily==true && File.exists?(target_file)# && (diff_day==max_diff_day) && (today > last_date) #&& (not Time.now.sunday?) && (not Time.now.saturday?)
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

$logger.info("end run daily append on #{Time.now}")

end

if $0==__FILE__
  strategy="hundun_1" 
	daily_append(strategy)
end