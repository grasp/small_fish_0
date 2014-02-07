require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../stock_history_daily.rb",__FILE__)
require 'net/http' 

module StockUtility

	def download_sina_real_time_and_append(strategy_file, strategy,symbol,whether_append)

	 #下载历史数据，如果没有历史数据
     history_target_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data)
     history_file=File.expand_path("#{symbol}.txt",history_target_folder)
     download_yahoo_history(strategy_file, strategy,symbol) unless File.exists?(history_file) && File.stat(history_file).size>0

     target_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).daily_data)


    sina_id=convert_yahoo_symbol_to_sina(symbol)
	  response= Net::HTTP.get("hq.sinajs.cn","/list=#{sina_id}" )
	  result_array= response.split(",")

	  yahoo_array=[]
	  yahoo_array<< result_array[30]
    yahoo_array<< result_array[1]
    yahoo_array<< result_array[4]
    yahoo_array<< result_array[5]
    yahoo_array<< result_array[3]
    yahoo_array<< (result_array[8].to_i)
    yahoo_array<< result_array[3]

    raise unless File.exists?(target_folder)
    result_file=File.new(File.expand_path("./#{result_array[30]}.txt",target_folder),"w+")
    result_file<<yahoo_array.join(",")
    result_file.close

   if (Time.now.hour<9 || Time.now.hour>15) && whether_append==true

       history_result_file=File.new(history_file,"a+")
       last_line=history_result_file.readlines[-1].to_s
       last_date=last_line.match(/\d\d\d\d-\d\d-\d\d/).to_s
       #puts last_line
       #只有当最后一行小于当前日期的时候才附加
       #但是如果中间少了好多天怎么办？ 凉拌先，最好保存在 daily data中
      
       history_result_file<<symbol+","+yahoo_array.join(",")+"\n" if last_date < result_array[30]
       history_result_file.close
       puts "append #{result_array[30]} daily data #{symbol} succ!"
   end

	end


end

if $0==__FILE__
	include StockUtility
	strategy_file=File.expand_path("../../utility/strategy.yml",__FILE__)
	strategy="hundun_1"
	symbol="000003.sz"
	whether_append=true
    download_sina_real_time_and_append(strategy_file,strategy,symbol,whether_append)
end