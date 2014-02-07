require File.expand_path("../../utility/utility.rb",__FILE__)

require File.expand_path("../../buy_record_tripple/triple_report_strategy_on_single_symbol.rb",__FILE__)

include StockReport

include StockUtility
include StockBuyRecordTripple
 group_number=(File.basename(__FILE__)).to_s.match(/\d+/).to_s.to_i

 #puts "group_number=#{group_number}"
 #puts $all_stock_list.keys.size/247

 range_start=1*(group_number-1)
 range_end=3*group_number

 group_list_array=$all_stock_list.keys[range_start,range_end]
strategy="hundun_1"
count=0
  integreated_report_file=File.join(Strategy.send(strategy).report,"#{strategy}_#{group_number}.txt")
group_list_array.each do |symbol|
	count+=1
	puts "group_number=#{group_number},count=#{count},symbol=#{symbol}"
	 initialize_singl_stock_folder(strategy,symbol)
   integreated_report_file<< report_strategy_history(strategy,symbol,true)
end

integreated_report_file.close