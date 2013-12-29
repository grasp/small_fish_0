require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../0_common/common.rb",__FILE__)
require File.expand_path("../../21_data_fix/delete_last_line.rb",__FILE__)
require File.expand_path("../../1_data_collection/history_data/save_download_history_data_from_yahoo.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/save_daily_data_into_one_text.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/append_daily_data_to_history.rb",__FILE__)
require File.expand_path("../../1_data_collection/history_data/append_history_data.rb",__FILE__)
require File.expand_path("../../22_data_validate/check_date_consistent.rb",__FILE__)
require File.expand_path("../../22_data_validate/validate_daily_data.rb",__FILE__)

require File.expand_path("../../20_data_process/append_data.rb",__FILE__)

require File.expand_path("../../30_signal_gen/append_signal.rb",__FILE__)


def price_file_data_fix_and_download
	start=Time.now
	#[["2013-11-22", 514], ["2013-11-21", 1919], ["2013-11-15", 1], ["2013-11-01", 25
#], ["2013-08-14", 1], ["2013-07-18", 1], ["2013-06-06", 1], ["2013-03-13", 1], [
#"2012-10-15", 1], ["2012-03-06", 1]]
	new_counter_array=check_price_file_consistent

#发现最后一日没有对齐，只好先删除最后一行的数据
if new_counter_array[0][1].to_i<2471-300#不可能一天有300只股票停牌的

	deleted_date=new_counter_array[0][0].gsub(/\"/,"").to_s
	$logger.error("last date <300, we have to delete the last date #{deleted_date}")
	#最后一个不对，只好删除最后一行
	$all_stock_list.keys.each do |symbol|
		source_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
		delete_last_line_with_date(source_file,deleted_date)
	end	

#删除后再检查一次，如果还有问题，需要人工检查，或者代码再检查
new_counter_array=check_price_file_consistent

end

#这个时候再检查最新日期，和当下日期的相距天数
last_line_date=new_counter_array[0][0].gsub(/\"/,"").to_s
today=Time.now.to_s[0..9]

#TBD节假日的特殊情况没有考虑进来
diff_day=get_diff_day(today,last_line_date)
if Time.now.monday?  #星期一相距的天数是3
  max_diff_day=3
elsif Time.now.sunday? 
  max_diff_day=2
else
  max_diff_day=1
end
$logger.info("get diff day =#{diff_day}, max_diff_day=#{max_diff_day} on time=#{Time.now} for last date=#{last_line_date}")

#如果相差一天，但是今天的时间是早上9点前，那么数据已经是最新的了，我们什么都做不了
if diff_day==max_diff_day && ((0..15).include?(Time.now.hour))
 $logger.info("we can do nothing as raw price data is already latest wait 10min, and need wait new data coming ")
 sleep 600 #休息10分钟后，继续看看是否需要数据下载	
 #return 
end

#下面为日期数据有差别
if diff_day >max_diff_day #&& not ((7..15).include?(Time.now.hour))
	#如果已经下载了，就不需要下载了
	target_folder=File.expand_path("./history_daily_data_3/#{today}","#{AppSettings.resource_path}")
    Dir.mkdir(target_folder) unless File.exists?(target_folder)

	if File.exists?(target_folder)
		f_counter=0
		Dir.new(target_folder).each do  |file|
          f_counter+=1
		end
if f_counter<2300 #说明已经下载过了
	$logger.info("start download history data on #{Time.now}")
	#下载历史数据，因为不在实时下载的时间窗口内了,下载一个月内的数据
	download_all_symbol_into_history_data("./history_daily_data_3/#{today}",30)
    $logger.info("end download history data on #{Time.now}")
	#append 历史数据
	append_all_history_data_for_folder("./history_daily_data_3/#{today}")
	$logger.info("append history data  done on #{Time.now}")
    else
    #说明此时还没有append
    append_all_history_data_for_folder("./history_daily_data_3/#{today}")
    $logger.info("history data 3 already downloaded")
   end
end

else #但是绝对不可以在交易时间下载实时数据，否则下载的就不是当日的收盘数据
    unless (0..15).include?(Time.now.hour)
	  #下载实时数据
	  $logger.info("start download daily data on #{Time.now}")
	  #如果已经下载，就不需要下载了，但是验证要通过
	  #先验证每日数据，如果验证不通过，就删除下载的文件，重新下载
	  validate_daily_date(today)

	  source_file=File.expand_path("./daily_data/#{today}.txt","#{AppSettings.resource_path}")
	  unless File.exists?(source_file)
        save_daily_data_into_one_text(today)
        $logger.info("end download daily data on #{Time.now}")
        #append实时数据
       
      else
    if diff_day.to_i>0 #如果有时间差就要附加
    	  $logger.info("start append daily data on #{Time.now}")
    	  append_daily_data_into_history(today) 
        $logger.info("end append daily data on #{Time.now}")
    else
        $logger.info("diff_day=#{diff_day}, no need to append daily data #{today}.txt")
    end
      end
    else
       $logger.info("it is not the right time to download daily data! #{Time.now}")
    end
end

#如果还是失败呢？
puts "cost time=#{Time.now-start}"

end



if $0==__FILE__
	
	$logger.info("start on today's data download and update ! #{Time.now}")
	start=Time.now
	price_file_data_fix_and_download
	new_counter_array=check_price_file_consistent

	#数据处理
	counter_hash=check_data_process_file_consistent_for_last_line
    $logger.info("processed file , counter hash=#{counter_hash}")
    
    append_all_data_process

    #信号处理

    counter_hash=check_signal_gen_file_consistent_for_last_line
    $logger.info("signal file , signal counter hash=#{counter_hash}")
    
    append_all_signal
    $logger.info("finish on today's data download and update ! #{Time.now}")
    puts "total cost time=#{Time.now-start}"

end
