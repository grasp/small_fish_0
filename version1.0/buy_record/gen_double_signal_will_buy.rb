
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../statistic_double_signal/generate_history_statistic.rb",__FILE__)

require "json"
module StockBuyRecord
include StockUtility


def update_double_signal_statistic(strategy,symbol,signal_array,statistic_hash,win_lost_flag)
  puts "signal_array=#{signal_array}"
end


#扫描某一天是否应该买
def generate_future_buy_list(strategy,symbol,date)

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

   #可能买的信号
    statistic_hash=Hash.new
    
    #第一次的话就载入初始文件
    if File.exists?(win_lost_statistic_path)
      potential_buy_contents=File.read(win_lost_statistic_path).split("\n")
    else
      potential_buy_contents=File.read(base_win_lost_statistic_path).split("\n")      
    end

    will_buy_array=[]

    potential_buy_contents.each do |line|
      result=line.split("#")
      result_array=JSON.parse(result[1])
      statistic_hash[result[0]]=result[1] #保存在hash

     # puts "result_array[1]=#{result_array[1]},result_array[3]=#{result_array[3]}"
      will_buy_array<< line if result_array[1].to_i>=count &&  result_array[1].to_i<10 && (result_array[3].to_f*100)>=already_win_percent #必须乘以100
    end


   #先更新输赢统计
#以下为比较部分
    signal_array=raw_signal_hash[date.to_s]

    return [date,0] if will_buy_array.size==0 #这里说明没有任何可以操作的统计

    happen_count=0
    will_buy_array.each do |line|
    result=line.split("#")
    signal_result=result[0].match(/\d+_\d+/).to_s

    signal_index=signal_result.split("_")
    real_signal=signal_index[0].to_s+"_"+signal_index[1].to_s+"_"+signal_array[signal_index[0].to_i].to_s.strip+signal_array[signal_index[1].to_i].to_s.strip
    
    happen_count+=1 if real_signal==result[0] # && real_signal.match("truetrue") #如果信号和发生次数多的相符合，那就是购买信号
    end

    return [date,happen_count]


#此处加上不应该买的列表，根据统计有一些信号的概率出现次数很多，概率很低，那就列为不买列表

  
#else
#  puts "#{symbol} already generated buy list"
#end
end



def generate_year_statistic(strategy,symbol,year)

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

# 做一些可能的初始化工作
    base_statistic_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,"base_statistic")
    Dir.mkdir(base_statistic_folder) unless File.exists?(base_statistic_folder)

    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,count_freq,"buy_record")
    Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)

    #这里产生的是双信号买卖列表
    buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","double_signal_buy_list.txt")


buy_list_file=File.new(buy_list,"w+")

  1.upto(12).each do |j|
  31.downto(1).each do |i|

    next unless Date.valid_date?(2013, j, -i)

    date = Date.new(2013, j, -i)
    #puts date
    unless (date.wday==6 || date.wday==0) #周末的交易都不算了

    next if raw_signal_hash[date.to_s].nil?
      result=generate_future_buy_list(strategy,symbol,date)

    #如果有买卖的信号产生，写入到买卖文件列表中
    if result[1]>0
      buy_list_file << (result[0].to_s +result[1].to_s+ "\n")     
    end

      #更新统计结果，避免重复上当
  # update_double_signal_statistic(strategy,symbol,raw_signal_hash[date.to_s],statistic_hash,win_lost_hash[date.to_s])
  # break
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
 symbol="000002.sz"
 generate_future_buy_list(strategy,symbol)
 puts "cost time=#{Time.now-start}"

end