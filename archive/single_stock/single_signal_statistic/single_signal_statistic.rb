require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../win_lost/generate_win_lost.rb",__FILE__)
require 'json'

include StockWinLost

#******************************************************************************************#
#单个信号的统计产生
#输入-信号文件，-输出单个信号变化的输赢统计
#单个信号从true->false,或者false->true对盈利的变化
#******************************************************************************************#

def generate_single_signal_statistic(strategy,symbol)
   signal_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
   win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
     
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
statistic_array[3]=(total_statistic[key][1].to_f/(total_statistic[key][0])).round(3)

end

    single_statistic_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
      Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"single_signal_statistic.txt")
     target_file=File.new(single_statistic_file,"w+")
   

      #total_statistic.sort_by
 total_statistic.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|
 # print key.to_s+value.to_s+"\n"
  target_file<<key.to_s+"#"+value.to_s+"\n"
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


#***********************************************************************************#
#根据单个信号的统计来买卖，看看效果如何呢？
#***********************************************************************************#
def generate_single_signal_buy_record(strategy,symbol)

    win_expect=Strategy.send(strategy).win_expect
    count_freq=Strategy.send(strategy).count_freq
    counter_freq_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,count_freq)
    Dir.mkdir(counter_freq_folder) unless File.exists?(counter_freq_folder)

    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,count_freq,"buy_record")

  # single_statistic_file=
    Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)

    #buy_list_done_txt=File.join()
    buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","single_signal_buy_list.txt")
  
   raw_signal_hash=Hash.new

  # if not File.exists?(buy_list)

   win_expect=Strategy.send(strategy).win_expect

   #第一步，载入信号文件
   signal_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
   
   signal_array=File.read(signal_file).split("\n")

   return nil if signal_array.size==0

   first_line=signal_array.shift(1)[0]
   signal_keys=JSON.parse(first_line)

   signal_key_hash=Hash.new
   signal_keys.each_index do |index|
   signal_key_hash[signal_keys[index]]=index
   end

   #puts signal_keys
   signal_array.each do |line|
    result=line.split("#")
    next if result[0].nil?   
    raw_signal_hash[result[0]]=JSON.parse(result[1])
  end

  signal_hash_array=raw_signal_hash.to_a.reverse

 #第二步，载入统计文件
    win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"single_signal_statistic.txt")

    count_freq=Strategy.send(strategy).count_freq
    count_freq_array=count_freq.split("_")

    count=count_freq_array[1].to_i
    already_win_percent=count_freq_array[3].to_f

   #可能买的信号
    potential_buy_contents=File.read(win_lost_statistic_path).split("\n")
    will_buy_array=[]

    potential_buy_contents.each do |line|
      result_array=JSON.parse(line.split("#")[1])
      will_buy_array<< line if result_array[1].to_i>=count && (result_array[3].to_f*100)>=already_win_percent #必须乘以100
    end
 #print will_buy_array.to_s
  #  puts "potential_buy_contents.size=#{potential_buy_contents.size},will_buy_array=#{will_buy_array.size}"

    buy_list_file=File.new(buy_list,"w+")

   date_hash=Hash.new{0}
   12.downto(1).each do |j|
   30.downto(1).each do |i|

      next unless Date.valid_date?(2013, j, -i)
      date = Date.new(2013, j, -i)

      unless (date.wday==6 || date.wday==0)
      next if raw_signal_hash[date.to_s].nil?
     
      signal_hash_array.each_index do |index|
     if signal_hash_array[index][0]==date.to_s
        # print signal_hash_array[index][1].to_s
          today_signal_array=signal_hash_array[index][1]

          yesterday_signal_array=signal_hash_array[index-1][1]

      today_signal_array.each_index do |index|

       if today_signal_array[index] !=yesterday_signal_array[index]
        key=index.to_s+today_signal_array[index].to_s+"_"+yesterday_signal_array[index].to_s

          will_buy_array.each do |line|
            date_hash[date]+=1 if line.match(key) && today_signal_array[signal_key_hash["t_ma2_bigger_ma5"]]=="true"
          end

       end 
     end
   end
   end
  end
 end
 end



 win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")


    win_lost_array=File.read(win_lost_file).split("\n")

    win_lost_hash=Hash.new

    win_lost_array.each do |line|
      result=line.split("#")
    
        win_lost_hash[result[0]]=result[1]
  
    end

     date_hash.each do |key,value|
  buy_list_file<<key.to_s+"#"+value.to_s+"#{win_lost_hash[key.to_s]}"+"\n"
 end

  buy_list_file.close

end

#*************************************************************
# 报告某日输赢
#*************************************************************


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
 def report_total_win_percent(strategy,symbol)

   expected_report_file=Strategy.send(strategy).end_date+"_"+Strategy.send(strategy).win_expect+"_"+Strategy.send(strategy).count_freq+"_single_signal.txt"
   
   report_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
       Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,\
       Strategy.send(strategy).single_report,expected_report_file)

   #加了一个是否需要重新生成报告的flag
  #  if File.exists?(report_file) && regenrate_flag==false
   #   if regenrate_flag==true || ( not File.exists?(report_file))
    # if  File.exists?(report_file)

   #   result=File.read(report_file)
    #  puts "alread generated =#{result}"
    #  return JSON.parse(result.strip)
      #end
   # end

      percent_num_day=Strategy.send(strategy).win_expect
      count_freq=Strategy.send(strategy).count_freq
      
      true_counter=0
      false_counter=0

      buy_record_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
       Strategy.send(strategy).end_date,percent_num_day,count_freq,"buy_record","single_signal_buy_list.txt")

       if File.exists?(buy_record_file) && File.stat(buy_record_file).size >0

        File.read(buy_record_file).split("\n").each do |date|
          result= report_win_percent_on_date(strategy,symbol,date.match(/\d\d\d\d-\d\d-\d\d/).to_s)
          true_counter+=1 if result==true
          false_counter+=1 if result==false
        end

      total=true_counter+false_counter      
      report_file_=File.new(report_file,"w+")      

     # report="{symbol=>#{symbol},total=>#{total},true_counter=>#{true_counter},false_counter=>#{false_counter},percent=>#{true_counter.to_f/total.to_f}}"+"\n"
      report=[total,true_counter,false_counter,true_counter.to_f/total.to_f]
      report_file_<< report.to_s+"\n"

      report_file_.close 
     # puts report
      return report unless total==0
      end
      return nil
 end


 def report_all_symbol(strategy)
  counter=0
    win_percent_report=File.join(Strategy.send(strategy).root_path,"report","single_signal_#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).count_freq}.txt")
  a=File.new(win_percent_report,"w+")
  $all_stock_list.keys.each do |symbol|
    counter+=1
    initialize_singl_stock_folder(strategy,symbol)
    puts "count=#{counter},symbol=#{symbol}"
    next if symbol=='600631.ss'
    generate_single_signal_buy_record(strategy,symbol)
    report=report_total_win_percent(strategy,symbol)
    a<<symbol+"#"+report.to_s+"\n" unless report.nil?
 end
 a.close
 end

 def calculate_stastistic_counter(strategy)
     c_counter=0
     counter=0
    $all_stock_list.keys.each do |symbol|
    counter+=1
    start=Time.now
    next if symbol=="600631.ss"

    puts "counter=#{counter},#{symbol}"
    single_statistic_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
      Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"single_signal_statistic.txt")

     if File.exists?(single_statistic_file)
      contents=File.read(single_statistic_file)
      contents.split("\n").each do |line|
      #  statistic=line.split("#")
      statistic=JSON.parse(line.split("#")[1])
      c_counter+=1 if statistic[1]>2 && statistic[3]>0.80
      end
     end
  end
  puts"c_counter=#{c_counter}"
 end

if $0==__FILE__
 start=Time.now
 strategy="hundun_1"
 #win_percent_folder="percent_5_num_5"
 # folder="percent_3_num_9_days"
 #generate_all_win_lost(strategy)
 symbol="000009.sz"
 initialize_singl_stock_folder(strategy,symbol)
 #generate_counter_for_percent(strategy,symbol,20,2,"2012-12-30")
# generate_counter_for_percent(strategy,symbol)
 #generate_single_signal_statistic(strategy,symbol)
# batch_generate_single_signal_statistic(strategy)

#calculate_stastistic_counter(strategy)
#generate_single_signal_buy_record(strategy,symbol)

 #report_total_win_percent(strategy,symbol)
 report_all_symbol(strategy)
 puts "cost=#{Time.now-start}"
end