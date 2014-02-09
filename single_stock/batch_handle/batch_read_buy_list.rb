require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)


include StockBuyRecord


  symbol_array=$all_stock_list.keys

  counter=0
strategy="hundun_1"
 (0).upto(symbol_array.size-1).each do |index|  
  
    start=Time.now
    symbol=symbol_array[index] 
buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","buy_list.txt")
if File.exists?(buy_list)

  if File.stat(buy_list).size >0
    puts "counter=#{counter},#{symbol},cost=#{Time.now-start}"
      counter+=1 
  end

end
 

  #  puts "counter=#{counter},#{symbol},cost=#{Time.now-start}"
  end