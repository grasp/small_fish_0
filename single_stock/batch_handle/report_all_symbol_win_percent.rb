require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../buy_record/report_total_win_percent.rb",__FILE__)

include StockBuyRecord
def report_all_symbol_win_percent(strategy)

	symbol_folder=Strategy.send(strategy).root_path
    symbol_array=[]
	Dir.new(symbol_folder).each do |folder|

		symbol_array<<folder if not( folder=="." || folder=="..")
	end

	report_path=Strategy.send(strategy).report
	Dir.mkdir(report_path) unless File.exists?(report_path)

	win_percent_report=File.join(Strategy.send(strategy).report,"#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).count_freq}.txt")
    report=File.new(win_percent_report,"w+")
    count=0
    symbol_array.each do |filename|
    	symbol=filename.gsub("\.txt","").to_s
     count+=1
     puts "count=#{count},symbol=#{symbol}"
	   buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
  	 Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq)
     result=report_total_win_percent(strategy,symbol)
  	 
	 report<< result+"\n"   unless result.match("NaN")
   end

   report.close

end

if $0==__FILE__
 report_all_symbol_win_percent("hundun_1")
end