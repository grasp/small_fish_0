require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

module StockRawData
include StockUtility

#下载yahoo的历史数据到历史文件夹
def download_yahoo_history(strategy,symbol)

  exe_path=File.expand_path("../../yahoo/yahoofinance.rb",__FILE__)
  days=Strategy.send(strategy).history_length.to_i

  command_run="ruby #{exe_path} -z -d #{days} #{symbol}"
  result=`#{command_run}`

  #puts result
  raise if result.size.nil?
  target_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data)
  raise unless File.exists?(target_folder)

  symbole_file_name=File.expand_path("#{symbol}.txt",target_folder)
  symbol_file=File.new(symbole_file_name,"w+")

  result.split("\n").reverse.each do |line|
    next if line.match("Retrieving")
    line_result=line.split(",")
    next if line_result[6]=="000" && line_result[0]!="000001.ss" # 扣除那些成交量为0的交易日数据
    symbol_file<<line+"\n"  
  end
    symbol_file.close
	end
end

#TODO 如何多线程来下载呢
def batch_download_yahoo_history(strategy)
   counter=0
   empty_counter=0
   start=Time.now
   empty_symbol=[]
   $all_stock_list.keys.each do |symbol|
      initialize_singl_stock_folder(strategy,symbol)
      target_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data)
      symbol_file_name=File.expand_path("#{symbol}.txt",target_folder)

      next if File.exists?(symbol_file_name) && File.stat(symbol_file_name).size > 0

      begin
        download_yahoo_history(strategy,symbol)
        #TODO 需要增加特殊异常处理，如果yahoo拒绝下载，需要多等一下
      rescue 
         File.delete(symbol_file_name) if File.exists?(symbol_file_name)
         empty_counter+=1
         empty_symbol<<symbol
         next
      end

      counter+=1
      if File.stat(symbol_file_name).size == 0
        empty_counter+=1; empty_symbol<<symbol 
      end

      puts "counter=#{counter},symbol=#{symbol}" if (counter%2) == 0 
      sleep 0.2

   end
    puts "empty counter=#{empty_counter},cost #{Time.now-start}"
    empty_symbol#返回下载失败的symbol
end

if $0==__FILE__
  include StockRawData
	strategy="hundun_1"
	symbol="000001.ss"
  initialize_singl_stock_folder(strategy,symbol)
	#StockRawData::download_yahoo_history(strategy,symbol)
  batch_download_yahoo_history(strategy)
end
