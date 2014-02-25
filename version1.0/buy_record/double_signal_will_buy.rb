
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../statistics/double_signal_history_statistic.rb",__FILE__)

require "json"
module StockBuyRecord
include StockUtility
include StockWinLost

def update_double_signal_statistic(strategy,symbol,signal_array,statistic_hash,win_lost_flag)
if signal_array.nil? || signal_array.size==0
  #puts "signal_array.nil? || signal_array.size==0,do not update"
 return [0,0] 
end
  #new_statistic_hash=Hash.new
 new_statistic_hash=statistic_hash

 ori_array_size=signal_array.size
 iter_array=(0..(ori_array_size-1)).to_a  
 possible_zuhe=[]
 total_size=ori_array_size

iter_array.each do |cycle|
 iter_array[cycle].upto(total_size-2).each do |i|
  possible_zuhe<<[cycle,i+1]
 end
end

#puts "possible_zuhe=#{possible_zuhe}"

possible_zuhe.each do |two_key_array|

  next if two_key_array.nil?
  new_key=""
  new_key<<two_key_array[0].to_s<<"_"<<two_key_array[1].to_s<<"_"<<signal_array[two_key_array[0]].to_s<<signal_array[two_key_array[1]].to_s
  #puts "original hash=#{statistic_hash[new_key]}"
  #statistic_array=[0,0,0,0]
  
  if statistic_hash.has_key?(new_key)
  # new_statistic_hash[new_key]=JSON.parse(statistic_hash[new_key])
  new_statistic_hash[new_key]=statistic_hash[new_key]
  # puts "new_statistic_hash[new_key]=#{new_statistic_hash[new_key]}"
 else
  new_statistic_hash[new_key]=[0,0,0,0]
  end
  #print "new_statistic_hash[new_key]=#{new_statistic_hash[new_key]}"
  new_statistic_hash[new_key][0]=(1+new_statistic_hash[new_key][0].to_i).to_i#总数加1
 #new_statistic_hash[new_key][0]+=1

  if win_lost_flag == "true"
    new_statistic_hash[new_key][1]=(1 +new_statistic_hash[new_key][1].to_i).to_i
  end
  if win_lost_flag == "false"
  new_statistic_hash[new_key][2]=(1 +new_statistic_hash[new_key][2].to_i).to_i
 end

  new_statistic_hash[new_key][3]=(new_statistic_hash[new_key][1].to_f/new_statistic_hash[new_key][0].to_f).round(3).to_f

 # new_statistic_hash[new_key]=statistic_array
  # puts "new_statistic_hash[new_key][3]=#{new_statistic_hash[new_key]}"
end

statistic_hash.each do |key,value|
  unless new_statistic_hash.has_key?(key)
   new_statistic_hash[key]=value
  end
end

win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"#{symbol}.txt")

#puts new_statistic_hash

return new_statistic_hash
s_file= File.new(win_lost_statistic_path,"w+")

  new_statistic_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|
  #puts value
  s_file<<key.to_s+"#"+value.to_s+"\n"
end
s_file.close
#print  "win_lost_statistic_path=#{win_lost_statistic_path}"
end


#扫描某一天是否应该买
def generate_future_buy_list(strategy,symbol,date,win_lost_flag,statistic_hash)

    win_expect=Strategy.send(strategy).win_expect
    count_freq=Strategy.send(strategy).count_freq
    counter_freq_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,count_freq)

   #有时候会产生新的配置，没有初始化过
    Dir.mkdir(counter_freq_folder) unless File.exists?(counter_freq_folder)
  
    raw_signal_hash=Hash.new

   #不再产生历史买卖列表
   #if not File.exists?(buy_list)

  #产生信号统计文件，如果还没有产生
    base_win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,"base_statistic","#{symbol}.txt")

    unless File.exists?(base_win_lost_statistic_path)
       generate_double_signal_statistic(stragety,symbol)
    end

  #如果此时还没有产生统计文件，说明是一个无法处理的股票，跳过
  unless File.exists?(base_win_lost_statistic_path)
    puts "no any base statistic"
    return 
  end

  #每次统计后，都需要更新在这里
  win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,"#{symbol}.txt")


  #第一步，载入信号文件
   signal_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
   
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


#第二步，载入统计文件
    count_freq_array=count_freq.split("_")

    count=count_freq_array[1].to_i
    already_win_percent=count_freq_array[3].to_f
    
    will_buy_array=[]  #放入会赢的统计
    will_lost_array=[] #放入会输的统计

    lost_probability=Strategy.send(strategy).lost_probability.split("_")

    statistic_hash.each do |key,value|

       will_buy_array<< key+"#"+value.to_s+"\n" if value[1].to_i>=count  && (value[3].to_f*100)>=already_win_percent #必须乘以100
       will_lost_array<<key+"#"+value.to_s+"\n" if value[1].to_i>=lost_probability[1].to_i && ((1-value[3].to_f)*100)>=lost_probability[3].to_i #必须乘以100
    end

 signal_array=raw_signal_hash[date.to_s]
 if signal_array.nil? || signal_array.size==0
  return [date,0,statistic_hash] 
 end


   #先更新输赢统计
   new_statistic_hash=update_double_signal_statistic(strategy,symbol,signal_array,statistic_hash,win_lost_flag)
   #以下部分比较历史信号，符合的就加入到 buy list 中
   return [date,0,new_statistic_hash] if will_buy_array.size==0 #这里说明没有任何可以操作的统计
 
    lost_happen_count=0

    will_lost_array.each do |line|
    result=line.split("#")
    signal_result=result[0].match(/\d+_\d+/).to_s

    signal_index=signal_result.split("_")
    real_signal=signal_index[0].to_s+"_"+signal_index[1].to_s+"_"+signal_array[signal_index[0].to_i].to_s.strip+signal_array[signal_index[1].to_i].to_s.strip
    
    lost_happen_count+=1 if real_signal==result[0] # && real_signal.match("truetrue") #如果信号和发生次数多的相符合，那就是购买信号
    end
    
    if lost_happen_count>0
      print "double signal-lost_happen_count=#{lost_happen_count} ,#{date},#{win_lost_flag}\n" 
      return [date,0,new_statistic_hash]  
    end

    happen_count=0 
   # print "#{will_buy_array}" +"\n"
    will_buy_array.each do |line|
      result=line.split("#")
      signal_result=result[0].match(/\d+_\d+/).to_s

      signal_index=signal_result.split("_")
      real_signal=signal_index[0].to_s+"_"+signal_index[1].to_s+"_"+signal_array[signal_index[0].to_i].to_s.strip+signal_array[signal_index[1].to_i].to_s.strip
      happen_count+=1 if real_signal==result[0] # && real_signal.match("truetrue") #如果信号和发生次数多的相符合，那就是购买信号
    end

    print "double signal happen count="+[date,happen_count].to_s+",#{win_lost_flag}"+"\n" if happen_count>0
    return [date,happen_count,new_statistic_hash]

end


def generate_year_statistic(strategy,symbol,year)

    win_expect=Strategy.send(strategy).win_expect
    count_freq=Strategy.send(strategy).count_freq

     raw_signal_hash=Hash.new
    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record")

    unless File.exists?(buy_record_folder)
      initialize_singl_stock_folder(strategy,symbol)
    end

  #产生信号统计文件，如果还没有产生
    base_win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,"base_statistic","#{symbol}.txt")

  #  unless File.exists?(base_win_lost_statistic_path)
       generate_double_signal_statistic(strategy,symbol)
   # end
 # raise unless File.exists?(base_win_lost_statistic_path)

    #读取win lost文件，是为了获取当日的日期中的输赢
    win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
    win_lost_array=File.read(win_lost_file).split("\n")
    win_lost_hash=Hash.new
    win_lost_array.each do |line|
      result=line.split("#")
      win_lost_hash[result[0]]=result[1]
    end


    #这里产生的是双信号买卖列表
    buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","double_signal_buy_list.txt")

     #获取base statistic
       base_win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
         Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic","#{symbol}.txt")

    return unless File.exists?(base_win_lost_statistic_path) #还没有统计文件产生，只好退出了

       statistic_hash=Hash.new

       File.read(base_win_lost_statistic_path).split("\n").each do |line|
        result=line.split("#")
        statistic_hash[result[0]]=JSON.parse(result[1])
       end

      # puts "statistic_hash size=#{statistic_hash.size}"
return if statistic_hash.size==0
buy_list_file=File.new(buy_list,"w+")

  1.upto(12).each do |j|
  31.downto(1).each do |i|

    next unless Date.valid_date?(year, j, -i)

    date = Date.new(year, j, -i)
    #puts date
    unless (date.wday==6 || date.wday==0) #周末的交易都不统计了

     #动态更新统计结果
      new_statistic_hash=statistic_hash if new_statistic_hash.nil?
      result=generate_future_buy_list(strategy,symbol,date.to_s,win_lost_hash[date.to_s],new_statistic_hash)
      new_statistic_hash=result[2]  #使用更新的统计hash

    #如果有买卖的信号产生，写入到买卖文件列表中
    if result[1]>0
      buy_list_file << (result[0].to_s + "#"+result[1].to_s + "#"+"#{win_lost_hash[date.to_s]}"+"\n")     
    end
   end
  end
 end
  buy_list_file.close
end
end
if $0==__FILE__ 

 include StockBuyRecord
 date="2013-11-13"
 start=Time.now
 strategy="hundun_1"
 symbol="000029.sz"

if false
     #读取win lost文件，是为了获取当日的日期中的输赢
    win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
    win_lost_array=File.read(win_lost_file).split("\n")

    win_lost_hash=Hash.new
    win_lost_array.each do |line|
      result=line.split("#")
     # if  result[0]<=end_date
      win_lost_hash[result[0]]=result[1]
     #end
    end
    #generate_future_buy_list(strategy,symbol,date,win_lost_hash[date.to_s])
end
    generate_year_statistic(strategy,symbol,2013)
    puts "cost time=#{Time.now-start}"

end