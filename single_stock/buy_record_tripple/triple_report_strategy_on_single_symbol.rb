require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)
require File.expand_path("../../utility/stock_list_init.rb",__FILE__)

require File.expand_path("../../raw_data/stock_history_daily.rb",__FILE__)

require File.expand_path("../../raw_data_process/save_analysis_result.rb",__FILE__)

require File.expand_path("../../signal/save_all_signal.rb",__FILE__)

require File.expand_path("../../win_lost/generate_win_lost.rb",__FILE__)
require File.expand_path("../../win_lost/generate_statistic_for_strategy.rb",__FILE__)

#require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)

require File.expand_path("../../triple_signal/statistic_triple_signal.rb",__FILE__)

require File.expand_path("../../buy_record_tripple/triple_gen_will_buy_by_strategy.rb",__FILE__)


require File.expand_path("../../buy_record_tripple/triple_report_total_win_percent.rb",__FILE__)

require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

module StockReport
  include StockUtility
  include StockRawDataProcess
  include StockSignal
  include StockWinLost
  #include StockBuyRecord
  include StockBuyRecordTripple

#只报告一次，避免后面的重复计算
  def report_strategy_history(strategy,symbol,regenrate_flag)

   expected_report=Strategy.send(strategy).end_date+"_"+Strategy.send(strategy).win_expect+"_"+Strategy.send(strategy).count_freq+".txt"
   
   report_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
       Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,Strategy.send(strategy).single_report,expected_report)

   #加了一个是否需要重新生成报告的flag
    #  return if File.exists?(report_file) && regenrate_flag==false

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

  # 6. generate statistic file 
  statistic_file=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).statistic,Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"#{symbol}.txt")

  unless File.exists?(statistic_file)
   generate_counter_for_percent(strategy,symbol)
  end

  #7. generate buy_record
  #buy_record_file=

  buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
  	Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq)
   #puts buy_record_folder


   #已经产生了就不产生了，比较费时间呵呵
  txt_count=0
   Dir.new(buy_record_folder).each do |date|
      # puts date
     	txt_count+=1  unless (date =="." ||date =="..")
     end
  # Dir.chdir(buy_record_folder)

  # generate_future_buy_list(strategy,symbol)
 # puts "txt_count=#{txt_count}"

 triple_signal_statistic(strategy,symbol)

    tripple_generate_future_buy_list(strategy,symbol)# if   txt_count ==2


  #8 generate report
  triple_report_total_win_percent(strategy,symbol,regenrate_flag)

  end #end of report_strategy_history
 end #end of module

if $0==__FILE__

	include StockReport
  start=Time.now
	strategy="hundun_1"
	symbol="000006.sz"
  report_strategy_history(strategy,symbol,true)
  puts "report cost time=#{Time.now-start}"
end
