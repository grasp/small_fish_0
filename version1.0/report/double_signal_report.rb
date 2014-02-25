
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../buy_record/double_signal_will_buy.rb",__FILE__)

def report_double_signal_single_symbol(strategy,symbol)

#如果没有buy_record_folder，那就初始化策略
    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record")

    unless File.exists?(buy_record_folder)
      initialize_singl_stock_folder(strategy,symbol)
    end


#如果没有买卖历史记录， 那就产生一个(问题是本来就没有的呢？)
double_signal_record=File.expand_path("./double_signal_buy_list.txt",buy_record_folder)

#unless File.exists?(double_signal_record)
	 generate_year_statistic(strategy,symbol,2013)
#end

if File.exists?(double_signal_record)
	if File.stat(double_signal_record).size==0
		return [symbol,0,0,0,0]
	else
		#puts "start calcualte"
		buy_count=0
		true_count=0
		false_count=0
      File.read(double_signal_record).split("\n").each do |line|
      	buy_count+=1      
      	result=line.split("#")
      	true_count+=1 if result[2]=="true"
      	false_count+=1 if result[2]=="false"      
      end
       return [symbol,true_count+false_count,true_count,false_count,(true_count.to_f/(true_count+false_count).to_f).round(2)]
	end
else
	return [symbol,0,0,0,0]
end

end

def batch_report_double_signal(strategy,symbol_array)
	report_array=[]

	symbol_array.each do |symbol|
	  report_array<<report_double_signal_single_symbol(strategy,symbol)	  
	end

    report_array.each do |report|
	  print report.to_s+"\n"
    end

    return report_array
end


if $0==__FILE__
	include StockUtility
	include StockBuyRecord
    start=Time.now
    batch_report_double_signal("hundun_1",$all_stock_list.keys[80..85])
	#print report_double_signal_single_symbol("hundun_1","000040.sz")
	puts "cost time=#{Time.now-start}"

end