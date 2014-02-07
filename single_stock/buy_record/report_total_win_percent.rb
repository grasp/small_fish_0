

require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require "json"
module StockBuyRecord
  include StockUtility

#报告某一日的输赢
 def report_win_percent_on_date(strategy,symbol,date)

 	percent_num_day=Strategy.send(strategy).win_expect
 	percent=percent_num_day.split("_")[1]
    number_day=percent_num_day.split("_")[3]
    #puts "percent=#{percent},number_day=#{number_day}"
 	win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,percent_num_day,"#{symbol}.txt")
 	win_result=File.read(win_lost_file).match(/#{date}.*/).to_s
 	#puts win_result
 	unless win_result.nil?
     return true if win_result.match("true")
     return false if win_result.match("false")
 	else
 	return -1
    end
 end

#只报告一次，避免重复报告
 def report_total_win_percent(strategy,symbol,regenrate_flag)

   expected_report=Strategy.send(strategy).end_date+"_"+Strategy.send(strategy).win_expect+"_"+Strategy.send(strategy).count_freq+".txt"
   report_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
       Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,Strategy.send(strategy).single_report,expected_report)

   #加了一个是否需要重新生成报告的flag
      return if File.exists?(report_file) && regenrate_flag==false

      percent_num_day=Strategy.send(strategy).win_expect
      count_freq=Strategy.send(strategy).count_freq
      
      true_counter=0
      false_counter=0

      buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
       Strategy.send(strategy).end_date,percent_num_day,count_freq,"buy_record")

      Dir.new(buy_record_folder).each do |date| #对每一个signal，统计各种盈利百分比可能
      	unless (date =="." ||date =="..")
      		result= report_win_percent_on_date(strategy,symbol,date.match(/\d\d\d\d-\d\d-\d\d/).to_s)
          true_counter+=1 if result==true
          false_counter+=1 if result==false
      	end
      end

      total=true_counter+false_counter
      
      report_file_=File.new(report_file,"w+")      
      report="{symbol=>#{symbol},total=>#{total},true_counter=>#{true_counter},false_counter=>#{false_counter},percent=>#{true_counter.to_f/total.to_f}}"+"\n"
      report_file_<< report


      report_file_.close

      puts report
      report
  
 end


end

if $0==__FILE__
	include StockBuyRecord

	strategy="hundun_1"
	symbol="000025.sz"
	date="2013-01-09"
 #puts report_win_percent_on_date(strategy,symbol,date)
 initialize_singl_stock_folder(strategy,symbol)
 report_total_win_percent(strategy,symbol,true)
end