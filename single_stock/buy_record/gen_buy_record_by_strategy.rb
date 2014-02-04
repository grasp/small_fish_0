
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

##603766.ss.txt#4_34falsetrue#
def scan_signal_on_date(algorithim_path,statistic_end_date,profit_percent,duration,win_count,win_percent,date)
    #buy_record_folder=File.expand_path("./buy_record/#{folder}","#{AppSettings.resource_path}")
    #Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)
    profit_percent_folder=File.expand_path("./percent_#{profit_percent}_num_#{duration}_days",algorithim_path)
    end_data_folder=File.expand_path("./end_date_#{statistic_end_date}",profit_percent_folder)
    percent_and_count_folder=File.expand_path("./percent_#{win_percent}_count_#{win_count}",end_data_folder)
    potential_buy=File.expand_path("./potential_buy",percent_and_count_folder)
    puts "potential_buy=#{potential_buy}"
    buy_record=File.expand_path("./buy_record/#{date}.txt",percent_and_count_folder)

	 # buy_record=File.expand_path("./buy_record/#{folder}/#{date}.txt","#{AppSettings.resource_path}")
    buy_record_file=File.new(buy_record,"w+")
    buy_record_hash=Hash.new{0}
    count=0
    Dir.new(potential_buy).each do |symbol|
      count+=1
      next if symbol=="." || symbol==".."
      potential_buy_contents=File.read(File.expand_path("./#{symbol}",potential_buy)).split("\n")

      #load symbol signal file
      source_file=File.expand_path("./signal/#{symbol}",algorithim_path)
      result2= File.read(source_file).match(/#{date}.*\n/).to_s

      next if result2.nil?
      next unless result2.match("#")
      temp=result2.split("#")
      next if temp.nil?
    # puts " now compute chance for #{symbol},#{count}"

       potential_buy_contents.each do |line|

       # puts line
        #this is from history
        result=line.split("#")
       # symbol=result[0]
        signal_result=result[0].match(/\d+_\d+/).to_s
        signal_index=signal_result.split("_")

        #below is from real signal
       # puts temp[1]
        signal_array=JSON.parse(temp[1])
       # print signal_array.to_s+"\n"
        real_signal=signal_index[0].to_s+"_"+signal_index[1].to_s+signal_array[signal_index[0].to_i].to_s+signal_array[signal_index[1].to_i].to_s
         #puts "real signal=#{real_signal},.result[0]=#{result[0]}"
       # buy_record_hash[symbol]+=1 
        
       if real_signal==result[0]
         buy_record_file<< symbol +"\n"
         break
        end
       end

    end
	#end

	buy_record_hash.each do |key,value|
		buy_record_file<<"#{key}"+"#"+"#{value}"+"\n"
	end

     buy_record_file.close

     File.delete(buy_record_file) if File.stat(buy_record_file).size==0
end

#扫描某一天是否应该买
def scan_signal_on_date_by_strategy(strategy,date,symbol)  

    count_freq=Strategy.send(strategy).count_freq
    count_freq_array=count_freq.split("_")

    count=count_freq_array[1].to_i
    win_percent=count_freq_array[3].to_f


    win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
     Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"#{symbol}.txt")


  #  signal_path=File.expand_path("#{symbol}.txt",$signal_path)
    signal_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
#puts signal_path

    counter_freq_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,count_freq)

    Dir.mkdir(counter_freq_folder) unless File.exists?(counter_freq_folder)

    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,count_freq,"buy_record")
    Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)

    buy_record_path=File.expand_path("#{date}.txt",buy_record_folder)

    raw_signal_on_date=  File.read(signal_path).match(/#{date}.*\n/).to_s.split(",")

    buy_record_file=File.new(buy_record_path,"a+")

    potential_buy_contents=File.read(win_lost_statistic_path).split("\n")

    #首先获取可能买的信号
    will_buy_array=[]

    potential_buy_contents.each do |line|
      result_array=JSON.parse(line.split("#")[1])
      will_buy_array<< line if result_array[1].to_i>=count && (result_array[3].to_f*100)>=win_percent #必须乘以100
    end
    if will_buy_array.size==0
      puts "will_buy_array.size=#{will_buy_array.size}"
    return 
    end
  #puts "will_buy_array.size=#{will_buy_array.size}"

    will_buy_array.each do |line|
   # puts line
    result=line.split("#")
       # symbol=result[0]
    signal_result=result[0].match(/\d+_\d+/).to_s

    signal_index=signal_result.split("_")

    real_signal=signal_index[0].to_s+"_"+signal_index[1].to_s+raw_signal_on_date[signal_index[0].to_i].to_s.strip+raw_signal_on_date[signal_index[1].to_i].to_s.strip
    
   # puts "date =#{date},real_signal=#{real_signal},result[0]=#{result[0]}"
    if real_signal==result[0] #如果信号和发生次数多的相符合，那就是购买信号
      buy_record_file<<symbol+"\n"
      break
    end
  end
  buy_record_file.close

  File.delete(buy_record_path) if File.stat(buy_record_path).size==0
end

def generate_future_buy_list(strategy)
  init_strategy_name(strategy)
  12.downto(1).each do |j|
  30.downto(1).each do |i|
    next unless Date.valid_date?(2013, j, -i)
    date = Date.new(2013, j, -i)

    unless (date.wday==6 || date.wday==0)
      #puts date
      scan_signal_on_date_by_strategy(strategy,date)
    end
  end
 end
end

end

if $0==__FILE__ 

  include StockBuyRecord
 date="2013-11-13"
 start=Time.now
 strategy="hundun_1"
 symbol="000004.sz"


12.downto(1).each do |j|
30.downto(1).each do |i|
    next unless Date.valid_date?(2013, j, -i)
  date = Date.new(2013, j, -i)

  unless (date.wday==6 || date.wday==0)
  	#puts date
    scan_signal_on_date_by_strategy(strategy,date,symbol) 
  end
end
end

puts "cost time=#{Time.now-start}"

end