require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../0_common/common.rb",__FILE__)
require File.expand_path("../../21_data_fix/delete_last_line.rb",__FILE__)
#require File.expand_path("../../1_data_collection/history_data/save_download_history_data_from_yahoo.rb",__FILE__)
#require File.expand_path("../../1_data_collection/daily_data/save_daily_data_into_one_text.rb",__FILE__)
require File.expand_path("../../22_data_validate/check_date_consistent.rb",__FILE__)
require File.expand_path("../../20_data_process/append_data.rb",__FILE__)

#在此之前， price cron已经保证了数据的一致性和完整性，在这里不再验证
#如果程序到达了这里，说面前面的检查和数据修复已经完成了
#这里只要完成自己这个层面的数据完整性检查和处理
def append_daily_data_cron

	#验证数据一致性
	#{"2013-11-21"=>2292, "2013-11-01"=>18},已经按照日期排序
	counter_hash=check_data_process_file_consistent_for_last_line
    $logger.info("processed file , counter hash=#{counter_hash}")
    
    append_all_data_process

    puts "done"
	#如果没有日线数据，但是历史数据里面包含了最新的日期，用历史数据来弥补

	#如果验证不一致，发邮件异常通知

	#验证过程中有异常，发邮件通知

end

if $0==__FILE__
	start=Time.now
    append_daily_data_cron
    puts "cost time=#{Time.now-start}"
end