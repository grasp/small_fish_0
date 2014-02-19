require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)
require File.expand_path("../../buy_record/report_total_win_percent.rb",__FILE__)


def batch_remove_signal(strategy)
  counter=0

 # start=Time.now
  $all_stock_list.keys.each do |symbol|
    counter+=1

    signal_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")

    File.delete(signal_file_path) if File.exists?(signal_file_path)
    puts "counter=#{counter},#{symbol}"
  end

end
def batch_remove_report(strategy)
  counter=0

 # start=Time.now
  $all_stock_list.keys.each do |symbol|
    counter+=1

  # signal_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
  expected_report_file=Strategy.send(strategy).end_date+"_"+Strategy.send(strategy).win_expect+"_"+Strategy.send(strategy).count_freq+".txt"
   
  report_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
       Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,\
       Strategy.send(strategy).single_report,expected_report_file)

if File.exists?(report_file)
   File.delete(report_file) 
    puts "counter=#{counter},#{symbol} ,deleted"
end

  

    buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","buy_list.txt")

if File.exists?(buy_list)
   File.delete(buy_list) 
    puts "buy list counter=#{counter},#{symbol} ,deleted"
end


  end



   file_name=Strategy.send(strategy).end_date+"_"+Strategy.send(strategy).win_expect+"_"+Strategy.send(strategy).count_freq+".txt"
  report_file_path=File.join(Strategy.send(strategy).root_path,"report",file_name)

   File.delete(report_file_path) if File.exists?(report_file_path)


end

if $0==__FILE__
	strategy="hundun_1"
   # #batch_remove_signal(strategy)
    batch_remove_report(strategy)
end