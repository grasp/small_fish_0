require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

require File.expand_path("../../buy_record/gen_will_buy_by_strategy.rb",__FILE__)
require File.expand_path("../../buy_record/report_total_win_percent.rb",__FILE__)

include StockBuyRecord

def batch_report_monthly_win_from_buy_list(strategy,month)

   win_counter=0
   lost_counter=0
   counter=0
   $all_stock_list.keys.each do |symbol|
  
    start=Time.now
    next if symbol=="600631.ss"
    buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","buy_list.txt")


   if File.exists?(buy_list) && File.stat(buy_list).size>0
   	  counter+=1
   	 # puts "counter=#{counter},symbol=#{symbol}"
     win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
     win_lost_hash=Hash.new
   File.read(win_lost_file).split("\n").each do |line|
  	 result=line.split("#")
  	# print result.to_s+"\n"
     win_lost_hash[result[0]]=result[1]
   end

   #puts win_lost_hash
   #break

   	   File.read(buy_list).split("\n").each do |line|
   	   #	puts line
           if line.match(/-#{month}-/)
        
           	if win_lost_hash[line]=="true"
           		win_counter+=1
           		  puts "#{symbol},#{line},true"
           	else
           		lost_counter+=1
           		 puts "#{symbol},#{line},false"
           	end
           end
   	   end
   end
   end

  report= [win_counter,lost_counter,(win_counter.to_f/(win_counter+lost_counter))]
  print "#{month} :"+report.to_s + "\n"
  report
end

if $0==__FILE__
	#9.downto(1).each do |i|
	#batch_report_monthly_win_from_buy_list("hundun_1","0#{i}")
   # end
   # batch_report_monthly_win_from_buy_list("hundun_1","10")
   # batch_report_monthly_win_from_buy_list("hundun_1","11")
    batch_report_monthly_win_from_buy_list("hundun_1","01")
end