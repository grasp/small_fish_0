
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)


include StockBuyRecord
def batch_generate_count_freq(strategy)

	symbol_folder=Strategy.send(strategy).root_path
    symbol_array=[]
	Dir.new(symbol_folder).each do |folder|

		symbol_array<<folder if not( folder=="." || folder=="..")
	end

	#report_path=Strategy.send(strategy).report

	#Dir.mkdir(report_path) unless File.exists?(report_path)

	#win_percent_report=File.join(Strategy.send(strategy).report,"#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).count_freq}.txt")
    #report=File.new(win_percent_report,"w+")
    count=0

    symbol_array.each do |filename|
    	symbol=filename.gsub("\.txt","").to_s
     count+=1
     puts "count=#{count},symbol=#{symbol}"  	 
	 generate_future_buy_list(strategy,symbol)
   end

   report.close

end

if $0==__FILE__
 batch_generate_count_freq("hundun_1")

end