require File.expand_path("../../utility/utility.rb",__FILE__)

module StockUtility


#下载yahoo的历史数据到历史文件夹
def download_yahoo_history(strategy_file, strategy,symbol)

  exe_path=File.expand_path("../../yahoo/yahoofinance.rb",__FILE__)
  days=Strategy.send(strategy).history_length.to_i

  command_run="ruby #{exe_path} -z -d #{days} #{symbol}"
  result=`#{command_run}`
  raise if result.size.nil?
  #store to file  
  #symbole_file_name=File.join(lib_path.parent,"history_daily_data","#{symbol}.txt")
  target_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data)
  raise unless File.exists?(target_folder)
  symbole_file_name=File.expand_path("#{symbol}.txt",target_folder)

  puts symbole_file_name
  symbol_file=File.new(symbole_file_name,"w+")
  result.split("\n").reverse.each do |line|
    next if line.match("Retrieving")
    line_result=line.split(",")
    next if line_result[6]=="000" # 扣除那些成交量为0的交易日数据
    symbol_file<<line+"\n"  
  end
    symbol_file.close
	end
end

if $0==__FILE__
    include StockUtility
	strategy_file=File.expand_path("../../utility/strategy.yml",__FILE__)
	strategy="hundun_1"
	symbol="000002.sz"
	#stock=Stock.new(strategy_file,strategy,symbol)
	StockUtility::download_yahoo_history(strategy_file,strategy,symbol)
end
