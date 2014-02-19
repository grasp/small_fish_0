require File.expand_path("../../utility/utility.rb",__FILE__)

require File.expand_path("../../report/report_strategy_on_single_symbol.rb",__FILE__)

include StockReport

 group_number=(File.basename(__FILE__)).to_s.match(/\d+/).to_s.to_i

 #puts "group_number=#{group_number}"
 puts $all_stock_list.keys.size/247

 range_start=247*(group_number-1)
 range_end=247*group_number


 group_list_array=$all_stock_list.keys[range_start,range_end]
strategy="hundun_1"
report_file=File.new(Strategy.send(strategy).report+"#{group_number}"+"#{strategy}_2","a+")
group_list_array.each do |symbol|
	start=Time.now
	report_file<<report_strategy_history(strategy,symbol,true)
	puts  "cost time=#{Time.now-start}"
end

report_file.close