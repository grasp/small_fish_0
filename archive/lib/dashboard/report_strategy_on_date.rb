
def report_strategy(strategy,date)

#首先检查原始统计是否在
#statistic_result=File.expand_path("",$statistic_file_path)
statistic_file_lenth=Dir["#{$statistic_file_path}/*"].length
unless statistic_file_lenth>2000
 puts "please generate first statistic file for #{$statistic_file_path} at first"
 generate_all_win_lost(strategy)
end

#看看counter统计
counter_statistic_file_length=Dir["#{$counter_statistic_path}/*"].length
unless counter_statistic_file_length>20
 puts "please generate  counter statistic #{$counter_statistic_path}"
 potential_buy_all_symbol(strategy)
end

#看看buy report

buy_report_statistic_length=Dir["#{$buy_record}/*"].length
unless buy_report_statistic_length>1
 puts "generate buy list  #{$counter_statistic_path}"
generate_future_buy_list(strategy)
end

#计算输赢比例
percent_file=File.expand_path("#{strategy}.txt",$count_freq)
puts percent_file
#unless File.exists?(percent_file)
	calculate_all_day_in_future(strategy) #if  File.stat(percent_file).size==0
#end

	
end
