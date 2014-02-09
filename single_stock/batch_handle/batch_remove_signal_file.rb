require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)
require File.expand_path("../../buy_record/report_total_win_percent.rb",__FILE__)

  counter=0
  strategy="hundun_1"
 # start=Time.now
  $all_stock_list.keys.each do |symbol|
    counter+=1

   # download_and_generate_statistic(strategy,symbol,true)


      signal_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")

      File.delete(signal_file_path) if File.exists?(signal_file_path)
    puts "counter=#{counter},#{symbol}"
  end