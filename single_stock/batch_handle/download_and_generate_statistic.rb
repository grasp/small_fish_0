require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)
require File.expand_path("../../utility/stock_list_init.rb",__FILE__)
require File.expand_path("../../raw_data/stock_history_daily.rb",__FILE__)
require File.expand_path("../../raw_data_process/save_analysis_result.rb",__FILE__)
require File.expand_path("../../signal/save_all_signal.rb",__FILE__)
require File.expand_path("../../win_lost/generate_win_lost.rb",__FILE__)
require File.expand_path("../../win_lost/generate_statistic_for_strategy.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

  include StockUtility
  include StockRawDataProcess
  include StockSignal
  include StockWinLost

#只报告一次，避免后面的重复计算
  def download_and_generate_statistic(strategy,symbol)


  # 6. generate statistic file 
  statistic_file=File.join(Strategy.send(strategy).root_path,symbol,\
      Strategy.send(strategy).statistic,Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"#{symbol}.txt")

  unless File.exists?(statistic_file) #只有当统计文件没有产生的时候做
   # 1.  初始化一些文件夹
     initialize_singl_stock_folder(strategy,symbol)

   #2.检查历史数据有没有下载
  	histroy_raw_data_file=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data,"#{symbol}.txt")
  	unless File.exists?(histroy_raw_data_file)
     download_yahoo_history(strategy,symbol)
  	end

  	# 3. raw data Process
    raw_data_process_file=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).raw_data_process,"#{symbol}.txt")

   unless File.exists?(raw_data_process_file)
     save_analysis_result(strategy,symbol)
   end
   #4. signal file process

   signal_file=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).signal_path,"#{symbol}.txt")

   unless File.exists?(signal_file)
    save_all_signal_to_file(strategy,symbol)
   end

   #5. winlost file process
   win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).win_lost_path,"#{symbol}.txt")

   unless File.exists?(win_lost_file)
    generate_win_lost(strategy,symbol)
   end


   generate_counter_for_percent(strategy,symbol)
  end
  
  end #end of report_strategy_history

 def batch_download_and_generate_statistic(strategy)
  counter=0
 # start=Time.now
  $all_stock_list.keys.each do |symbol|
    counter+=1
    start=Time.now
    download_and_generate_statistic(strategy,symbol)
    puts "counter=#{counter},#{symbol},cost=#{Time.now-start} sec"
    
   #break
  end
 end

if $0==__FILE__

  start=Time.now
	strategy="hundun_1"
	symbol="000006.sz"
  #download_and_generate_statistic(strategy,symbol)
  batch_download_and_generate_statistic(strategy)
  puts "report cost time=#{Time.now-start}"
end
