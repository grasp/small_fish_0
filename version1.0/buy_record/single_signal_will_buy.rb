require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../statistics/single_signal_history_statistic.rb",__FILE__)

require "json"
module StockBuyRecord

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
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic","single_signal_statistic.txt")

  #产生统计文件
  unless File.exists?(win_lost_statistic_path)
  	generate_single_signal_statistic(strategy,symbol)
  end

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


end

if $0==__FILE__
   include StockUtility
   include StockBuyRecord
	strategy="hundun_1"
	symbol="000005.sz"

    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date, Strategy.send(strategy).win_expect, Strategy.send(strategy).count_freq,"buy_record")

    unless File.exists?(buy_record_folder)
      initialize_singl_stock_folder(strategy,symbol)
    end

	generate_single_signal_buy_record(strategy,symbol)
	#generate_single_signal_statistic(strategy,symbol)
end