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

     single_name="single_#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).single_win_freq}_#{Strategy.send(strategy).single_lost_freq}.txt"
   
    win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic",single_name)

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
if will_buy_array.size>=Strategy.send(strategy).limited_win_signal
#  puts " give up when too much signal  count happen #{will_buy_array.size},limit #{Strategy.send(strategy).limited_win_signal}"
 # return [date,0,new_statistic_hash] 
  #这个限制没有必要加，尤其是高盈利概率的时候，丧失一些机会
end

if today_signal_array[0]=="false"
 # puts " give up as today_signal_array[0]==false "
  #return [date,0,new_statistic_hash] 
  #这个也暂时不要看看？上次统计表现良好
end


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
  	#print "lost_happen_count=#{lost_happen_count} on #{date},#{win_lost_flag}\n"
    return [date,0,new_statistic_hash]
  end


#此处为买入条件，增加一个额外条件
   win_happen_count=0
   today_signal_array.each_index do |index|
   if today_signal_array[index] !=yesterday_signal_array[index]
      key=index.to_s+today_signal_array[index].to_s+"_"+yesterday_signal_array[index].to_s
     
      will_buy_array.each do |line|
      	if line.split("#")[0]==key #&& today_signal_array[signal_key_hash["t_ma2_bigger_ma5"]]=="true"
          # puts "key=#{key} line =#{line},match=#{line.match(key)}"
         win_happen_count+=1        
      	end
      end
   end 
   end
     if win_happen_count>0
   	# print "win_happen_count=#{win_happen_count} on #{date},#{win_lost_flag}\n"
   	end

 return [date,win_happen_count,new_statistic_hash]
end



def generate_single_signal_will_buy_date(strategy,symbol,date)

     win_expect=Strategy.send(strategy).win_expect

  #check statistic  file
  single_name="single_#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).single_win_freq}_#{Strategy.send(strategy).single_lost_freq}.txt"

  win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic",single_name)

  #产生统计文件
  unless File.exists?(win_lost_statistic_path)
    generate_single_signal_statistic(strategy,symbol)
  end
  #如果还没有统计文件，就可以放弃了
  unless File.exists?(win_lost_statistic_path)
    puts "not exists #{win_lost_statistic_path}"
   return 
  end

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

  #load price_file for compare the real price
  price_hash=get_price_hash_from_history(strategy,symbol)
  price_array=price_hash.to_a
  #print price_array

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

   date_hash=Hash.new{0}
 
       today_signal_array=[]
       yesterday_signal_array=[]


      today_index=0
      price_array.each_index do |index|
        if price_array[index][0]==date.to_s
          today_index=index
          break
        end
      end

      today_price=price_array[today_index][1]
      number_day=win_expect.split("_")[3].to_i
     # print "number day=#{today_index+number_day} \n"
     unless  today_index+number_day>=price_array.size      
      future_price=price_array[today_index+number_day][1]  #number_day
    else
      future_price=price_array[today_index][1]  #number_day
     end


      signal_hash_array.each_index do |index|
      	#puts "#{signal_hash_array[index][0]},#{date.to_s}"
        #t_ma2_bigger_ma5 ==true
        if signal_hash_array[index][0]==date.to_s #&& signal_hash_array[index][1][51]==true && signal_hash_array[index][1][10]==true && signal_hash_array[index][1][11]==true
        	#puts "=="
           today_signal_array=signal_hash_array[index][1]
           yesterday_signal_array=signal_hash_array[index-1][1]  

           # print   "today:#{today_signal_array}, yesterday:#{yesterday_signal_array}"   +"\n" 
           new_statistic_hash=statistic_hash if new_statistic_hash.nil?
           result=generate_single_signal_buy_record(strategy,symbol,date.to_s,today_signal_array,yesterday_signal_array,win_lost_hash[date.to_s],new_statistic_hash)
           new_statistic_hash=result[2]

           #如果有买卖的信号产生，写入到买卖文件列表中

           report_line=""
           report_line<<(result[0].to_s + "#"+result[1].to_s + "#"+"#{win_lost_hash[date.to_s]}")  
  
           #hash 的值为几个基本数据，依次为开盘，最高，最低，收盘，成交量
           report_line << "#" +(((future_price[3].to_f-today_price[3].to_f)/today_price[3].to_f)*100).round(2).to_s + "#" +(((future_price[1].to_f-today_price[3].to_f)/today_price[3].to_f)*100).round(2).to_s 
           #report_line <<"#" +(( (future_price[3].to_f+(future_price[1].to_f-today_price[3].to_f)/2)/today_price[3].to_f)*100).round(2).to_s
            report_line <<"\n"
             # report_line<<"#"+"#{today_price.to_s}"+"#{future_price.to_s}"+ "\n"
           if result[1]>0 
     	      return  report_line
           end
       end # end if signal_hash_array[index][0]==date.to_s
   end # signal_hash_array.each_index do
   return nil
end


def batch_handle_single_signal_buy(strategy,stock_array,date)
	report_array=[]
	count =0 
   stock_array.each do |symbol|

   buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date, Strategy.send(strategy).win_expect, Strategy.send(strategy).count_freq,"buy_record")

    unless File.exists?(buy_record_folder)
      initialize_singl_stock_folder(strategy,symbol)
    end


    puts "#{symbol},#{count}"
    count+=1
    result=generate_single_signal_will_buy_date(strategy,symbol,date)
    report_array<<"#{symbol}"+"#"+result.to_s unless result.nil?
  end
 # return report

 puts "+++++++++++++++++"
 puts report_array.size
 print report_array
 puts "+++++++++++++++++"

  report_path=File.join(Strategy.send(strategy).root_path,"#{date}.txt")
  report_file=File.new(report_path,"w+")

  report_array.each do |line|
  	report_file<< line +"\n"
  end
  	report_file.close
  	report_array
end

end
if $0==__FILE__
   include StockUtility
   include StockBuyRecord
   start=Time.now
	strategy="hundun_1"
	symbol="000005.sz"

    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date, Strategy.send(strategy).win_expect, Strategy.send(strategy).count_freq,"buy_record")

    unless File.exists?(buy_record_folder)
      initialize_singl_stock_folder(strategy,symbol)
    end

	#generate_single_signal_buy_record(strategy,symbol)
	#generate_single_signal_statistic(strategy,symbol)
  stock_array=$all_stock_list.keys[0..2041]
	#generate_single_signal_will_buy_year(strategy,symbol,2013)
	#generate_single_signal_will_buy_date(strategy,symbol,"2014-02-28")
	print batch_handle_single_signal_buy(strategy,stock_array,"2014-03-05")
 # batch_handle_single_signal_buy(strategy,stock_array)

 puts "cost #{Time.now - start}"
end