require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../statistics/single_signal_history_statistic.rb",__FILE__)

require "json"
module StockBuyRecord

#***********************************************************************************#
#根据单个信号的统计来买卖，看看效果如何呢？
#***********************************************************************************#
def generate_single_signal_buy_record(strategy,symbol,date,today_signal_array,yesterday_signal_array,win_lost_flag,statistic_hash)

  new_statistic_hash=statistic_hash

    #buy_list_done_txt=File.join()
    buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","single_signal_buy_list.txt")
  
   raw_signal_hash=Hash.new

  # if not File.exists?(buy_list)

   win_expect=Strategy.send(strategy).win_expect

   #第一步，载入信号文件
  # signal_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")   
  # signal_array=File.read(signal_file).split("\n")
   if today_signal_array.size==0 || yesterday_signal_array.size==0
   	puts "today_signal_array=0!"
   return [date,0,statistic_hash] 
 end


 #第二步，载入统计文件
    win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic","single_signal_statistic.txt")

  #产生统计文件
  unless File.exists?(win_lost_statistic_path)
  	generate_single_signal_statistic(strategy,symbol)
  end


    win_count_freq=Strategy.send(strategy).single_win_freq.split("_")
    lost_count_freq=Strategy.send(strategy).single_lost_freq.split("_")
 
    #count=count_freq_array[1].to_i
    #already_win_percent=count_freq_array[3].to_f

    will_buy_array=[]
    will_lost_array=[]

    statistic_hash.each do |key,value|
      #result_array=JSON.parse(line.split("#")[1])
        #     print "\n#{value[1]},#{win_count_freq[1].to_i},#{value[3].to_f}\n"
      will_buy_array<< key.to_s+"#"+"#{value.to_s}"+"\n" if value[1].to_i>=win_count_freq[1].to_i && (value[3].to_f*100)>=win_count_freq[3].to_i #必须乘以100
      will_lost_array<< key.to_s+"#"+"#{value.to_s}"+"\n" if value[1].to_i>=lost_count_freq[1].to_i && ((1-value[3].to_f)*100)>=lost_count_freq[3].to_i #必须乘以100
    end

    # 现在更新统计hash,避免重复上当
    today_signal_array.each_index do |index|
       key=index.to_s+today_signal_array[index].to_s+"_"+yesterday_signal_array[index].to_s
      # puts new_statistic_hash[key]
       unless new_statistic_hash.has_key?(key)
         new_statistic_hash[key]=[0,0,0,0]
       end
       new_statistic_hash[key][0]+=1
       new_statistic_hash[key][1]+=1 if win_lost_flag=="true"
       new_statistic_hash[key][2]+=1 if win_lost_flag=="false"
       new_statistic_hash[key][3]= (new_statistic_hash[key][1].to_f/new_statistic_hash[key][0]).round(3)     
     end

     # print "will_buy_array=#{will_buy_array}\n"
#      print "will_lost_array=#{will_lost_array}\n"

#puts "will_buy_array size=#{will_buy_array.size},will_lost_array.size=#{will_lost_array.size}"

#信号太多，说明骗线多吗？避免风险，我们不做
 return [date,0,new_statistic_hash] if will_buy_array.size>=Strategy.send(strategy).limited_win_signal

return [date,0,new_statistic_hash] if today_signal_array[0]=="false"

   lost_happen_count=0
   today_signal_array.each_index do |index|
   if today_signal_array[index] !=yesterday_signal_array[index]
      key=index.to_s+today_signal_array[index].to_s+"_"+yesterday_signal_array[index].to_s

      will_lost_array.each do |line|
      	 lost_happen_count+=1 if line.match(key)# && today_signal_array[signal_key_hash["t_ma2_bigger_ma5"]]=="true"
      end
   end 
   end

  if lost_happen_count>0
  	print "lost_happen_count=#{lost_happen_count} on #{date},#{win_lost_flag}\n"
    return [date,0,new_statistic_hash]
  end



   win_happen_count=0
   today_signal_array.each_index do |index|
   if today_signal_array[index] !=yesterday_signal_array[index]
      key=index.to_s+today_signal_array[index].to_s+"_"+yesterday_signal_array[index].to_s
     
      will_buy_array.each do |line|

      	if line.split("#")[0]==key# && today_signal_array[signal_key_hash["t_ma2_bigger_ma5"]]=="true"
          # puts "key=#{key} line =#{line},match=#{line.match(key)}"
         win_happen_count+=1        
      	end
      end
   end 
   end
     if win_happen_count>0
   	 print "win_happen_count=#{win_happen_count} on #{date},#{win_lost_flag}\n"
   	end

 return [date,win_happen_count,new_statistic_hash]
end



def generate_single_signal_will_buy_year(strategy,symbol,year)

	buy_record=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record")


    buy_list=File.expand_path("./single_signal_buy_list.txt",buy_record)
  
    unless File.exists?(buy_record)
       initialize_singl_stock_folder(strategy,symbol)
    end

  #check statistic  file
  win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic","single_signal_statistic.txt")

  #产生统计文件
  unless File.exists?(win_lost_statistic_path)
    generate_single_signal_statistic(strategy,symbol)
  end

   return unless File.exists?(win_lost_statistic_path)

   signal_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
   raw_signal_hash=Hash.new

   signal_array=File.read(signal_file).split("\n")
   return nil if signal_array.size==0
   first_line=signal_array.shift(1)[0]
   signal_keys=JSON.parse(first_line)

   #puts signal_keys
   signal_array.each do |line|
    result=line.split("#")
    next if result[0].nil?   
    raw_signal_hash[result[0]]=JSON.parse(result[1])
  end

  signal_hash_array=raw_signal_hash.to_a


 #第二步，载入统计文件
    win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic","single_signal_statistic.txt")

   statistic_hash=Hash.new
   File.read(win_lost_statistic_path).split("\n").each do |line|
   	result=line.split("#")
   	statistic_hash[result[0]]=JSON.parse(result[1])
   end


    win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
    win_lost_array=File.read(win_lost_file).split("\n")
    win_lost_hash=Hash.new

    win_lost_array.each do |line|
      result=line.split("#")    
        win_lost_hash[result[0]]=result[1]  
    end

 buy_list_file=File.new(buy_list,"w+")
   date_hash=Hash.new{0}

   12.downto(1).each do |j|
   30.downto(1).each do |i|
      next unless Date.valid_date?(2013, j, -i)
      date = Date.new(2013, j, -i)
      unless (date.wday==6 || date.wday==0)
      next if raw_signal_hash[date.to_s].nil?  
       today_signal_array=[]
       yesterday_signal_array=[]

      signal_hash_array.each_index do |index|
      	#puts "#{signal_hash_array[index][0]},#{date.to_s}"
     if signal_hash_array[index][0]==date.to_s
     	#puts "=="
        today_signal_array=signal_hash_array[index][1]
        yesterday_signal_array=signal_hash_array[index-1][1]  

       # print   "today:#{today_signal_array}, yesterday:#{yesterday_signal_array}"   +"\n" 
        new_statistic_hash=statistic_hash if new_statistic_hash.nil?
        result=generate_single_signal_buy_record(strategy,symbol,date.to_s,today_signal_array,yesterday_signal_array,win_lost_hash[date.to_s],new_statistic_hash)
        new_statistic_hash=result[2]

     #如果有买卖的信号产生，写入到买卖文件列表中
    if result[1]>0
      buy_list_file << (result[0].to_s + "#"+result[1].to_s + "#"+"#{win_lost_hash[date.to_s]}"+"\n")     
    end
     end

   end
end
end
end


 buy_list_file.close

end
end

def batch_handle_single_signal_buy(strategy,stock_array)
  stock_array.each do |symbol|
    puts symbol
    generate_single_signal_will_buy_year(strategy,symbol,2013)
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

	#generate_single_signal_buy_record(strategy,symbol)
	#generate_single_signal_statistic(strategy,symbol)
  stock_array=$all_stock_list.keys[200,200]
#	generate_will_buy_year(strategy,symbol,2013)
  batch_handle_single_signal_buy(strategy,stock_array)
end