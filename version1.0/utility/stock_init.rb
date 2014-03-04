require File.expand_path("../utility.rb",__FILE__)
require File.expand_path("../../utility/stock_list_init.rb",__FILE__)

module StockUtility

	def initialize_singl_stock_folder(strategy,symbol)

      $strategy_config=Strategy.send(strategy)

	   #mk root path
	    $root_path=$strategy_config.root_path
      Dir.mkdir($root_path)  unless File.exists?($root_path)

      #mk symbol folder
      symbol_path=File.expand_path(symbol,$root_path)
      Dir.mkdir(symbol_path) unless File.exists?(symbol_path)

      #raw_data
      raw_data_path=File.expand_path($strategy_config.raw_data,symbol_path)
      Dir.mkdir(raw_data_path) unless File.exists?(raw_data_path)

      #history_data
      history_data_path=File.expand_path($strategy_config.history_data,raw_data_path)
      Dir.mkdir(history_data_path) unless File.exists?(history_data_path)

      #daily_data
      daily_data_path=File.expand_path($strategy_config.daily_data,raw_data_path)
      Dir.mkdir(daily_data_path) unless File.exists?(daily_data_path)

      #raw_data_process
      raw_data_process_path=File.expand_path($strategy_config.raw_data_process,symbol_path)
      Dir.mkdir(raw_data_process_path) unless File.exists?(raw_data_process_path)

      #signal_path
      signal_path=File.expand_path($strategy_config.signal_path,symbol_path)
      Dir.mkdir(signal_path) unless File.exists?(signal_path)

      #win_lost_path
      win_lost_path=File.expand_path($strategy_config.win_lost_path,symbol_path)
      Dir.mkdir(win_lost_path) unless File.exists?(win_lost_path)

      #statistic_path
      statistic_path=File.expand_path($strategy_config.statistic,symbol_path)
      Dir.mkdir(statistic_path) unless File.exists?(statistic_path)

      #end_date_path
      #start_date=$strategy_config.start_date
      end_date=$strategy_config.end_date
      end_date_path=File.expand_path("#{end_date}",statistic_path)
      Dir.mkdir(end_date_path) unless File.exists?(end_date_path)

      #win_expect
      win_expect_path=File.expand_path($strategy_config.win_expect,end_date_path)
      Dir.mkdir(win_expect_path) unless File.exists?(win_expect_path)

      #count_freq
      count_freq_path=File.expand_path($strategy_config.count_freq,win_expect_path)
      Dir.mkdir(count_freq_path) unless File.exists?(count_freq_path)

      #统计基础文件夹
      base_statistic_folder=File.expand_path("base_statistic",win_expect_path)
      Dir.mkdir(base_statistic_folder) unless File.exists?(base_statistic_folder)

      #buy_record
      buy_record_path=File.expand_path($strategy_config.buy_record,count_freq_path)
      Dir.mkdir(buy_record_path) unless File.exists?(buy_record_path)

      #report
      report_path=File.expand_path($strategy_config.single_report,count_freq_path)
      Dir.mkdir(report_path) unless File.exists?(report_path)
	#end

      #total_report=
      total_report=File.join($strategy_config.root_path,$strategy_config.total_report)
      Dir.mkdir(total_report) unless File.exists?(total_report)
     # end

      #init global
    

     # puts "end_of stock init"

      end



end

def get_working_date_hash
  working_date_file=File.expand_path("../../utility/2014.txt",__FILE__)
  $working_day_hash=Hash.new

  File.read(working_date_file).split("\n").each do |line|
    result=line.split("#")
    $working_day_hash[result[1]]=result[0]
    end
    return $working_day_hash
end


  load_stock_list_file if $all_stock_list.nil?
  get_working_date_hash if $working_day_hash.nil?

  result=`ipconfig`
  if result.match("10.69.70.34")
   ENV['http_proxy']="http://10.140.19.49:808"
   ENV['https_proxy']="https://10.140.19.49:808"
  end

if $0==__FILE__
include StockUtility
	#strategy_file=File.expand_path("../strategy.yml",__FILE__)
	strategy="hundun_1"
	symbol="000002.sz"
	#stock=Stock.new(strategy_file,strategy,symbol)
	initialize_singl_stock_folder(strategy,symbol)
end