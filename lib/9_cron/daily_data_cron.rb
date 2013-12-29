require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def daily_data_download_cron
	#首先验证数据的一致性，假设历史数据验证是正确的

	#如果数据不一致，删除最后一行

	#如果上一个工作日的日期不是相差一天或者三天，需要用历史数据来弥补了

	#重新下载最近一天的日线数据，如果已经过了实时下载的窗口时间，只能用历史数据来弥补

	#再次验证数据一致性，如果还没有成功，试着再重新下载一次

end

def append_daily_data_cron

	#验证数据一致性

	#如果没有日线数据，但是历史数据里面包含了最新的日期，用历史数据来弥补

	#如果验证不一致，发邮件异常通知

	#验证过程中有异常，发邮件通知

end

def daily_data_process_cron

	#验证数据已经下载，并且一致性通过，上一次的日期为确实是上一个工作日的数据
	#如果上一个工作日的日期不是相差一天或者三天，需要用历史数据来处理了

	#计算附加日期，如果出错，邮件通知

end

def daily_signal_cron
	#已经下载，并且验证日线和处理数据的一致性
	#工作日检查，如果工作日不匹配，通知一下，但是照常
	#append signal ,如果异常，邮件通知
end

if $0==__FILE__
  daily_data_download_cron
end
