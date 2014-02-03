require File.expand_path("../utility.rb",__FILE__)
module StockUtility

	def initialize_singl_stock_folder(strategy_file, strategy,symbol)

            puts "strategy_file=#{strategy_file}"
	   raise unless File.exists?(strategy_file) #策略文件必须在哪里
	   #mk root path
	  $root_path=Strategy.send(strategy).root_path
      Dir.mkdir($root_path)  unless File.exists?($root_path)

      #mk symbol folder
      symbol_path=File.expand_path(symbol,$root_path)
      Dir.mkdir(symbol_path) unless File.exists?(symbol_path)

      #raw_data
      raw_data_path=File.expand_path(Strategy.send(strategy).raw_data,symbol_path)
      Dir.mkdir(raw_data_path) unless File.exists?(raw_data_path)

      #history_data
      history_data_path=File.expand_path(Strategy.send(strategy).history_data,raw_data_path)
      Dir.mkdir(history_data_path) unless File.exists?(history_data_path)

      #daily_data
      daily_data_path=File.expand_path(Strategy.send(strategy).daily_data,raw_data_path)
      Dir.mkdir(daily_data_path) unless File.exists?(daily_data_path)

      #raw_data_process
      raw_data_process_path=File.expand_path(Strategy.send(strategy).raw_data_process,symbol_path)
      Dir.mkdir(raw_data_process_path) unless File.exists?(raw_data_process_path)

      #signal_path
      signal_path=File.expand_path(Strategy.send(strategy).signal_path,symbol_path)
      Dir.mkdir(signal_path) unless File.exists?(signal_path)

      #win_lost_path
      win_lost_path=File.expand_path(Strategy.send(strategy).win_lost_path,symbol_path)
      Dir.mkdir(win_lost_path) unless File.exists?(win_lost_path)

      #statistic_path
      statistic_path=File.expand_path(Strategy.send(strategy).statistic,symbol_path)
      Dir.mkdir(statistic_path) unless File.exists?(statistic_path)

      #end_date_path
      start_date=Strategy.send(strategy).start_date
      end_date=Strategy.send(strategy).end_date
      end_date_path=File.expand_path("#{start_date}_#{end_date}",statistic_path)
      Dir.mkdir(end_date_path) unless File.exists?(end_date_path)

      #win_expect
      win_expect_path=File.expand_path(Strategy.send(strategy).win_expect,end_date_path)
      Dir.mkdir(win_expect_path) unless File.exists?(win_expect_path)

      #count_freq
      count_freq_path=File.expand_path(Strategy.send(strategy).count_freq,win_expect_path)
      Dir.mkdir(count_freq_path) unless File.exists?(count_freq_path)

      #buy_record
      buy_record_path=File.expand_path(Strategy.send(strategy).buy_record,count_freq_path)
      Dir.mkdir(buy_record_path) unless File.exists?(buy_record_path)

      #report
      report_path=File.expand_path(Strategy.send(strategy).report,count_freq_path)
      Dir.mkdir(report_path) unless File.exists?(report_path)
	end
end



if $0==__FILE__
include StockUtility
	strategy_file=File.expand_path("../strategy.yml",__FILE__)
	strategy="hundun_1"
	symbol="000002.sz"
	#stock=Stock.new(strategy_file,strategy,symbol)
	StockUtility::initialize_singl_stock_folder(strategy_file,strategy,symbol)
end