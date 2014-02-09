require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)
require File.expand_path("../../buy_record/report_total_win_percent.rb",__FILE__)

include StockBuyRecord

def batch_report_win_lost_on_buy_list(strategy,regeneration_flag)
  symbol_array=$all_stock_list.keys

  counter=0
#strategy="hundun_1"

report_dir=File.join(Strategy.send(strategy).root_path,"report")
Dir.mkdir(report_dir) unless File.exists?(report_dir)



file_name=Strategy.send(strategy).end_date+"_"+Strategy.send(strategy).win_expect+"_"+Strategy.send(strategy).count_freq+".txt"
report_file_path=File.join(Strategy.send(strategy).root_path,"report",file_name)

report_hash=Hash.new


 (0).upto(symbol_array.size-1).each do |index|    
    start=Time.now
    symbol=symbol_array[index] 

  single_report=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"report")
   Dir.mkdir(single_report) unless File.exists?(single_report)

#puts "#{single_report}"
   buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","buy_list.txt")

#puts "#{buy_list}"

if File.exists?(buy_list)
  if File.stat(buy_list).size >0
   # puts "counter=#{counter},#{symbol},cost=#{Time.now-start}"
    # generate_future_buy_list("hundun_1",symbol,true)
    result=report_total_win_percent(strategy,symbol,false)
    report_hash[symbol]=result unless result.nil?
    counter+=1 
  end
end
end

#puts report_hash
 report_file=File.new(report_file_path,"w+")
 report_hash.sort_by {|_key,_value| _value[3].to_f}.reverse.each do |key,value|
  report_file<<key.to_s+"#"+value.to_s+"\n"
end
report_file.close

end

if $0==__FILE__
  batch_report_win_lost_on_buy_list("hundun_1",false)
end