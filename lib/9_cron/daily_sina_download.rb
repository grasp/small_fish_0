require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/save_daily_data_into_one_text.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/append_daily_data_to_history.rb",__FILE__)
require File.expand_path("../../20_data_process/append_data.rb",__FILE__)
require File.expand_path("../../30_signal_gen/append_signal.rb",__FILE__)
require File.expand_path("../../0_common/common.rb",__FILE__)
require File.expand_path("../../22_data_validate/validate_daily_data.rb",__FILE__)

#需要对其这几个文件的最后一行的日期才可以做以下的操作，需要做更多的健壮性代码

def daily_append(strategy)

init_strategy_name(strategy)
$logger.info("start run daily append on #{Time.now}" )

#获取上次最新的下载日期
last_date1=get_last_date_on_daily_k("000009.sz").to_s
last_date2=get_last_date_on_daily_k("000008.sz").to_s

last_date1>=last_date2 ? last_date=last_date1 : last_date=last_date2#总是取比较大的，比较小的可能因为停盘

today=Time.now.to_s[0..9]


 if today==last_date
 	$logger.info("today==last_date=#{last_date}, exit with 0, already download latest" )
    return 0
 end


# 必须顺序附加，节假日就麻烦了，呵呵
diff_day=get_diff_day(today,last_date1)
puts "today=#{today},last_date=#{last_date1},diff_day=#{diff_day}"
Time.now.monday? ? max_diff_day=3 : max_diff_day=1

target_file=File.expand_path("#{today}.txt",$daily_data)

#删除文件，如果文件无效
valid_daily=validate_daily_date(today) if File.exists?(target_file)

if valid_daily==false
  File.delete(target_file)
  $logger.info("delete the daily data file , and try download again") 
end

#如果还没下载，或者下载文件有问题，准备再重新下载
if (not File.exists?(target_file)) && (Time.now.hour<8 || Time.now.hour>15 || Time.now.sunday? || Time.now.saturday?)
  save_today_daily_data #下载日线数据到一个文件

#最多下载四次
3.downto(0).each do |i|
valid_daily=validate_daily_date(today) if File.exists?(target_file)

if valid_daily==false
  File.delete(target_file)
  $logger.info("cycle #{i},valid_daily==false")
  sleep 200
  #try download again
  save_today_daily_data
  
else
	break
end

end

# 最后的检查
valid_daily=validate_daily_date(today) if File.exists?(target_file)

if valid_daily==false
  File.delete(target_file)
	$logger.info("try 4 times download daily data, failed!!,return -1  ")
return -1  
end
end


#如果新浪下载失败，那么就用历史数据下载了

if valid_daily==true && File.exists?(target_file) && (diff_day==max_diff_day) && (today > last_date) #&& (not Time.now.sunday?) && (not Time.now.saturday?)

  result=appened_today_daily_data

  $logger.info("appened_today_daily_data result=#{result} ")

  if result==0
  	begin
      append_all_data_process
      append_all_signal
    rescue Exception
	  $logger.info("#{$@}.split(",")}")
    end
  end

else
	$logger.info("did not append any data as append condition not true")
end
$logger.info("end run daily append on #{Time.now}")
end



if $0==__FILE__
  strategy="hundun_1" 
	daily_append(strategy)
end