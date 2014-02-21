require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../signal/generate_history_signal.rb",__FILE__)
require File.expand_path("../generate_win_lost.rb",__FILE__)
require 'json'

module StockWinLost
  include StockUtility
  include StockSignal
def generate_win_lost_counter()
	win_lost=File.expand_path("./win_lost","#{AppSettings.resource_path}")
	Dir.new(win_lost).each do |folder|
      puts folder
	end
end

#统计输赢的信号比例
def generate_double_signal_statistic(stragety,symbol)

    #percent_num_day_folder="percent_#{percent}_num_#{number_day}_days"
    percent_num_day_folder=Strategy.send(stragety).win_expect
    #puts "stragety=#{stragety},percent_num_day_folder=#{percent_num_day_folder}"

    end_date=Strategy.send(stragety).end_date
    result=percent_num_day_folder.split("_")
    percent=result[1].to_i
    number_day=result[3].to_i

    puts "percent=#{percent},number_day=#{number_day}"

    signal_file=File.join(Strategy.send(stragety).root_path,symbol,Strategy.send(stragety).signal_path,"#{symbol}.txt")
    win_lost_file=File.join(Strategy.send(stragety).root_path,symbol,Strategy.send(stragety).win_lost_path,percent_num_day_folder,"#{symbol}.txt")

    unless File.exists?(signal_file)
      generate_history_signal(stragety,symbol)
    end
    #here generate winlost file if not exist
    unless File.exists?(win_lost_file)
      generate_win_lost(stragety,symbol)
    end
  
    win_lost_array=File.read(win_lost_file).split("\n")

    win_lost_hash=Hash.new
    signal_hash=Hash.new

    win_lost_array.each do |line|
    	result=line.split("#")
      if  result[0]<=end_date
    	win_lost_hash[result[0]]=result[1]
     end
    end
    
   # print win_lost_hash
   signal_array=File.read(signal_file).split("\n")
   first_line=signal_array.shift(1)[0]
   signal_keys=JSON.parse(first_line)

   #puts signal_keys
   signal_array.each do |line|
    result=line.split("#")
    temp=JSON.parse(result[1])

   temp.each_index do |index|
    	temp[index]=temp[index].to_s
    end
  if result[0]<=end_date  #只统计某个时间段的
    signal_hash[result[0]]=temp
  end
   end

ori_array_size=signal_keys.size
 iter_array=(0..(ori_array_size-1)).to_a  
 possible_zuhe=[]
 total_size=ori_array_size

iter_array.each do |cycle|
 iter_array[cycle].upto(total_size-1).each do |i|
 	possible_zuhe<<[cycle,i]
 end
end
#puts "possible_zuhe.size=#{possible_zuhe.size}"
#puts "possible_zuhe=#{possible_zuhe}"

count=0
win_hash=Hash.new{0}
lost_hash=Hash.new{0}

possible_zuhe.each do |zuhe|
	a=zuhe[0]
	b=zuhe[1]
  c=zuhe[0].to_s
  d=zuhe[1].to_s
 key_1=c+"_"+d+"_"
win_lost_hash.each do |date,w_l|

signal_array=signal_hash[date]
  key=""
	key<<key_1<<signal_array[a]<<signal_array[b]
  if w_l=="true"
    win_hash[key]+=1
  else
    lost_hash[key]+=1
  end	
end
end
total_hash=Hash.new

win_hash.each do |key,value|
	if lost_hash.has_key?(key)
      total_hash[key]=[value,lost_hash[key]] #知道了这个信号组合的输和赢的数字
	else
     total_hash[key]=[value,0]#初始化
	end
end

lost_hash.each do |key,value|
	unless win_hash.has_key?(key)
     total_hash[key]=[0,value] #初始化
	end
end

total_hash.each do |key,value|
	total=value[0]+value[1]
	total_hash[key]=[total,value[0],value[1],(value[0]/total.to_f)]
end

#win_lost_statistic=File.expand_path("./#{folder}/#{symbol}.txt",$end_date_path)
end_date_folder=File.join(Strategy.send(stragety).root_path,symbol,Strategy.send(stragety).statistic,Strategy.send(stragety).end_date)
Dir.mkdir(end_date_folder) unless File.exists?(end_date_folder)

win_lost_statistic_folder=File.join(Strategy.send(stragety).root_path,symbol,Strategy.send(stragety).statistic,end_date,percent_num_day_folder)
Dir.mkdir(win_lost_statistic_folder) unless File.exists?(win_lost_statistic_folder)

base_statistic_folder=File.join(Strategy.send(stragety).root_path,symbol,Strategy.send(stragety).statistic,end_date,percent_num_day_folder,"base_statistic")
Dir.mkdir(base_statistic_folder) unless File.exists?(base_statistic_folder)

win_lost_statistic=File.join(base_statistic_folderr,"#{symbol}.txt")

s_file= File.new(win_lost_statistic,"w+")

  total_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|

  s_file<<key.to_s+"#"+value.to_s+"\n"
end
s_file.close

end


def batch_generate_double_signal_statistic(stragety)
    #folder="percent_1_num_1_days"
    folder=AppSettings.send(stragety).win_expect
    counter=0
    percent_folder=$win_expect
   #Dir.mkdir(percent_folder) unless File.exists?(percent_folder)
	 $all_stock_list.keys.each do |symbol|
		counter+=1
		puts "#{symbol},#{counter}"
		 signal_file=File.expand_path("./#{symbol}.txt",$signal_path)
		 win_lost_statistic=File.expand_path("./#{folder}/#{symbol}.txt",$end_date_path)
		 if File.exists?(signal_file) && (not File.exists?(win_lost_statistic))
		  # generate_double_signal_statistic(symbol,folder,stragety)
       generate_double_signal_statistic(strategy,symbol)
	   end
	end
end
end

if $0==__FILE__
  include StockWinLost
 start=Time.now
 strategy="hundun_1"
 #win_percent_folder="percent_5_num_5"
 # folder="percent_3_num_9_days"
 #generate_all_win_lost(strategy)
 symbol="000005.sz"
 #generate_counter_for_percent(strategy,symbol,20,2,"2012-12-30")
 generate_double_signal_statistic(strategy,symbol)
 puts "cost=#{Time.now-start}"
end