
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
  require "json"
module StockBuyRecord
  include StockUtility


#could buy 是把那些潜在的可能买的都列了出来，然后根据这个列表去扫描
#603766.ss.txt#30_73falsetrue#[12, 12, 0, 1.0]
#603766.ss.txt#21_72truetrue#[11, 11, 0, 1.0]
#603766.ss.txt#4_34falsetrue#[14, 14, 0, 1.0]

def  load_buy_object_into_hash(folder,win_file)
    source_file=File.expand_path("./buy_object/#{folder}/#{win_file}.txt","#{AppSettings.resource_path}")
    contents=File.read(source_file).split("\n")
    could_buy_array=[]
    contents.each do |line|
    	result= line.split("#")
        could_buy_array<<result[0]+"#"+result[1]
    end
  could_buy_array
end


#扫描某一天是否应该买
def scan_signal_on_date_by_strategy(strategy,date,symbol,signal_array,statistic_array)  




   # buy_record_path=File.expand_path("#{date}.txt",buy_record_folder)

    # raw_signal_on_date=  File.read(signal_path).match(/#{date}.*\n/).to_s.split(",")
   # puts "date=#{date},raw_signal_hash =#{raw_signal_hash[date]}"

    if statistic_array.size==0
     # puts "statistic_array size ==0"
    return 
    end

    statistic_array.each do |line|

    result=line.split("#")
    signal_result=result[0].match(/\d+_\d+/).to_s

    signal_index=signal_result.split("_")

    real_signal=signal_index[0].to_s+"_"+signal_index[1].to_s+"_"+signal_array[signal_index[0].to_i].to_s.strip+signal_array[signal_index[1].to_i].to_s.strip
    
     #puts "date =#{date},real_signal=#{real_signal},result[0]=#{result[0]}"
    if real_signal==result[0] #如果信号和发生次数多的相符合，那就是购买信号
     # puts "date #{date} will buy"
     return date
    end
  end
return nil
end

def generate_future_buy_list(strategy,symbol)

    win_expect=Strategy.send(strategy).win_expect
    count_freq=Strategy.send(strategy).count_freq
    counter_freq_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,count_freq)

    Dir.mkdir(counter_freq_folder) unless File.exists?(counter_freq_folder)

    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,count_freq,"buy_record")
    Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)

      #buy_list_done_txt=File.join()
    buy_list=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record","buy_list.txt")

   raw_signal_hash=Hash.new

  if not File.exists?(buy_list)

    win_expect=Strategy.send(strategy).win_expect

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

  #print raw_signal_hash["2013-01-24"]

#第二步，载入统计文件
    win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,"#{symbol}.txt")

    count_freq=Strategy.send(strategy).count_freq
    count_freq_array=count_freq.split("_")

    count=count_freq_array[1].to_i
    already_win_percent=count_freq_array[3].to_f

   #可能买的信号
    potential_buy_contents=File.read(win_lost_statistic_path).split("\n")
    will_buy_array=[]

    potential_buy_contents.each do |line|
      result_array=JSON.parse(line.split("#")[1])
     # puts "result_array[1]=#{result_array[1]},result_array[3]=#{result_array[3]}"
      will_buy_array<< line if result_array[1].to_i>=count && (result_array[3].to_f*100)>=already_win_percent #必须乘以100
    end

  buy_list_file=File.new(buy_list,"w+")

  12.downto(1).each do |j|
  30.downto(1).each do |i|
    next unless Date.valid_date?(2013, j, -i)
    date = Date.new(2013, j, -i)
    unless (date.wday==6 || date.wday==0)
    next if raw_signal_hash[date.to_s].nil?
      result=scan_signal_on_date_by_strategy(strategy,date,symbol,raw_signal_hash[date.to_s],will_buy_array)
    unless result.nil?
     # puts "#{symbol},#{date} will_buy"
      buy_list_file << (result.to_s + "\n")
    end
    end
  end
 end
  buy_list_file.close
else
  puts "#{symbol} already generated buy list"
end
end

end

if $0==__FILE__ 

 include StockBuyRecord
 date="2013-11-13"
 start=Time.now
 strategy="hundun_1"
 symbol="000002.sz"
 generate_future_buy_list(strategy,symbol,true)
 puts "cost time=#{Time.now-start}"

end