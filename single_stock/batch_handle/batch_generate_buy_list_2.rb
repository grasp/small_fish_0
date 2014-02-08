
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)


include StockBuyRecord


  symbol_array=$all_stock_list.keys

 counter=0
 (0).upto(symbol_array.size-1).each do |index|  
 	counter+=1

    symbol=symbol_array[index]
    puts "counter=#{counter},#{symbol}"
    generate_future_buy_list("hundun_1",symbol)
  end


