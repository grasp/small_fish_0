
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)


include StockBuyRecord


def batch_generate_buy_list(strategy, regeneration_flag)

  symbol_array=$all_stock_list.keys
  counter=0
  (symbol_array.size-1).downto(0).each do |index|  
    counter+=1
    start=Time.now
    symbol=symbol_array[index]  
   next if symbol=="600631"
    generate_future_buy_list(strategy,symbol,regeneration_flag)
    puts "generate buy list:#{counter},#{symbol},cost=#{Time.now-start}"
  end

end


if $0==__FILE__
  batch_generate_buy_list("hundun_1", false)
end


