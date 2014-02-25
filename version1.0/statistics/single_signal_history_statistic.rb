require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../signal/generate_history_signal.rb",__FILE__)
require File.expand_path("../../utility/generate_win_lost.rb",__FILE__)
require 'json'


#******************************************************************************************#
#单个信号的统计产生
#输入-信号文件，-输出单个信号变化的输赢统计
#单个信号从true->false,或者false->true对盈利的变化
#******************************************************************************************#
    include StockWinLost
    include StockSignal
def generate_single_signal_statistic(strategy,symbol)

   signal_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
   win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
     

    #generate signal file if not exists

    unless File.exists?(signal_file)
      generate_history_signal(strategy,symbol)
    end

    return unless File.exists?(signal_file)
  #here generate winlost file if not exist
  unless File.exists?(win_lost_file)
  percent_num_day_folder_name=Strategy.send(strategy).win_expect

  percent=percent_num_day_folder_name.split("_")[1].to_i
  number_day=percent_num_day_folder_name.split("_")[3].to_i
    generate_win_lost(strategy,symbol)
  end

  #产生某一天的输赢
    win_lost_array=File.read(win_lost_file).split("\n")
    win_lost_hash=Hash.new
    signal_hash=Hash.new

    win_lost_array.each do |line|
      result=line.split("#")
      if  result[0]<=Strategy.send(strategy).end_date
      win_lost_hash[result[0]]=result[1]
     end
    end

  #产生信号Hash
   signal_array=File.read(signal_file).split("\n")
   first_line=signal_array.shift(1)[0]

   return if first_line.nil?

   signal_keys=JSON.parse(first_line)

   #puts signal_keys
   signal_array.each do |line|
    result=line.split("#")
    temp=JSON.parse(result[1])

   temp.each_index do |index|
      temp[index]=temp[index].to_s
    end
  if result[0]<=Strategy.send(strategy).end_date  #只统计某个时间段的
    signal_hash[result[0]]=temp
  end
   end

   win_statstic_hash=Hash.new{0}
   lost_statstic_hash=Hash.new{0}
   signal_hash_array=signal_hash.to_a.reverse
   signal_hash_array.each_index do |s_index|
   next if s_index==0
   date=signal_hash_array[s_index][0]
   array1=signal_hash_array[s_index][1]
   array2=signal_hash_array[s_index-1][1]

  array1.each_index do |index|
  if array1[index] !=array2[index]
    key=index.to_s+array1[index]+"_"+array2[index]
    if win_lost_hash[date]=="true"
      win_statstic_hash[key]+=1 
    else
      lost_statstic_hash[key]+=1 
    end
  end
 end
end

total_statistic=Hash.new
win_statstic_hash.each do |key,value|  
  total_statistic[key]=[0,0,0]
  total_statistic[key][0]+=value #total +1
  total_statistic[key][1]+=value #win +1

  if lost_statstic_hash.has_key?(key)
      total_statistic[key][0]+=lost_statstic_hash[key] #total +1
      total_statistic[key][2]+=lost_statstic_hash[key] #lost +1
  end
end

 lost_statstic_hash.each do |key,value|
  unless win_statstic_hash.has_key?(key)
       total_statistic[key]=[0,0,0]
      total_statistic[key][0]+=value #total +1
      total_statistic[key][2]+=value #lost +1
  end
 end

total_statistic.each do |key,statistic_array|
statistic_array[3]=(total_statistic[key][1].to_f/(total_statistic[key][0])).round(4)

end

#产生base statistic
 single_statistic_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
      Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic","single_signal_statistic.txt")

     target_file=File.new(single_statistic_file,"w+")
  # puts "single_statistic_file=#{single_statistic_file}"

      #total_statistic.sort_by
 total_statistic.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|
 # print key.to_s+value.to_s+"\n"
  target_file<<key.to_s+"#"+value.to_s+"#"+"#{signal_keys[key.to_i]}"+"\n"
 end
   target_file.close
end

def batch_generate_single_signal_statistic(strategy)
    counter=0
    $all_stock_list.keys.each do |symbol|
    counter+=1
    start=Time.now
    next if symbol=="600631.ss"
    puts "counter=#{counter},#{symbol}"
    generate_single_signal_statistic(strategy,symbol)
  end
 end

if $0==__FILE__
    include StockUtility
    include StockWinLost
	strategy="hundun_1"
	symbol="000005.sz"

   base_statistic_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
      Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic")

   unless File.exists?(base_statistic_folder)
   	initialize_singl_stock_folder(strategy,symbol)
   end

   generate_single_signal_statistic(strategy,symbol)

end