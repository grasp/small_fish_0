
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../buy_record/single_signal_will_buy.rb",__FILE__)

def report_single_signal_single_symbol(strategy,symbol)

#如果没有buy_record_folder，那就初始化策略
    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record")

    unless File.exists?(buy_record_folder)
      initialize_singl_stock_folder(strategy,symbol)
    end


#如果没有买卖历史记录， 那就产生一个(问题是本来就没有的呢？)
single_name="single_#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).single_win_freq}_#{Strategy.send(strategy).single_lost_freq}.txt"
single_signal_record=File.expand_path(single_name,buy_record_folder)

unless File.exists?(single_signal_record)
	 generate_single_signal_will_buy_year(strategy,symbol,2013)
end

if File.exists?(single_signal_record)
	if File.stat(single_signal_record).size==0
		return [symbol,0,0,0,0]
	else
		#puts "start calcualte"
		buy_count=0
		true_count=0
		false_count=0
      File.read(single_signal_record).split("\n").each do |line|
      	buy_count+=1      
      	result=line.split("#")
      	if result[3].to_f>=2
      	  true_count+=1 
        else
      	  false_count+=1# if result[4].to_f<=0   
        end
      end
       return [symbol,true_count+false_count,true_count,false_count,(true_count.to_f/(true_count+false_count).to_f).round(2)]
	end
else
	return [symbol,0,0,0,0]
end
end

def batch_report_single_signal(strategy,symbol_array)
	report_array=[]
    count=0
	symbol_array.each do |symbol|
		count+=1
		puts "count=#{count},symbol=#{symbol}"
		report=report_single_signal_single_symbol(strategy,symbol)	
	    report_array<<  report if report[1]>0
	end

    report_array.each do |report|
	  print report.to_s+"\n"
    end
    
    total_report=[0,0,0,0]
    report_array.each do |report|
     total_report[0]+=report[1]
     total_report[1]+=report[2]
     total_report[2]+=report[3]
    end
    total_report[3]=((total_report[1].to_f)/total_report[0]).round(2)
    puts total_report
end

def batch_report_on_date(strategy,symbol_array)

date_hash=Hash.new


    date_array=[0,0,0,0]

    total_date_array=[]

	symbol_array.each do |symbol|

    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record")
    single_name="single_#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).single_win_freq}_#{Strategy.send(strategy).single_lost_freq}.txt"
    
    single_signal_record=File.expand_path(single_name,buy_record_folder)
    if File.exists?(single_signal_record) && File.stat(single_signal_record).size>0
      File.read(single_signal_record).split("\n").each do |line|
       total_date_array<<line.to_s+"\n"
      end
    end 
end
total_date_array.each do |line|
  result=line.split("#")

  if date_hash.has_key?(result[0])
      date_array=date_hash[result[0]]
  else
      date_array=[0,0,0,0]
  end
  
 date_array[0]+=1

  if result[3].to_f>0
    date_array[1]+=1
  else
    date_array[2]+=1
  end
date_hash[result[0]]=date_array
end
date_hash.each do |date,date_array|
  date_array[3]=(date_array[1].to_f/date_array[0].to_f).round(2) unless date_array[0]==0
end

print "date_hash size=#{date_hash.size}\n"

total_date=date_hash.size
fail_date=0
win_date=0
 date_hash.sort_by {|_key,_value| _key}.each do |key,value|

  if value[3]<1
    fail_date+=1
   puts "#{key}=#{value}<<<<<" 
 else
  win_date+=1
     puts "#{key}=#{value}" 
 end
  end
print "fail date=#{fail_date},win_date=#{win_date}"
end

if $0==__FILE__
	include StockUtility
	include StockBuyRecord
    start=Time.now
    strategy="hundun_1"
    batch_report_single_signal("hundun_1",$all_stock_list.keys[0..2470])
   # batch_report_on_date(strategy,$all_stock_list.keys[0..2470])
	#print report_double_signal_single_symbol("hundun_1","000040.sz")
	puts "cost time=#{Time.now-start}"

end