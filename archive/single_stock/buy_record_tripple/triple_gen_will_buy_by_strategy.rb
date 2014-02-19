
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
  require "json"
module StockBuyRecordTripple
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
def scan_signal_on_date_by_strategy_tripple(strategy,date,symbol)  

    count_freq=Strategy.send(strategy).count_freq
    count_freq_array=count_freq.split("_")

    count=count_freq_array[1].to_i
    already_win_percent=count_freq_array[3].to_f

    win_expect=Strategy.send(strategy).win_expect

    #expected_win_percent=win_expect.split("_")[1].to_f
    #number_day=win_expect.split("_")[3]

    win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,"triple_signal.txt")

  #  signal_path=File.expand_path("#{symbol}.txt",$signal_path)
    signal_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
  #puts signal_path

    counter_freq_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,count_freq)

    Dir.mkdir(counter_freq_folder) unless File.exists?(counter_freq_folder)

    buy_record_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    Strategy.send(strategy).end_date,win_expect,count_freq,"buy_record_triple")
    Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)

    buy_record_path=File.expand_path("#{date}.txt",buy_record_folder)

    raw_signal_on_date=  File.read(signal_path).match(/#{date}.*\n/).to_s.split(",")



    potential_buy_contents=File.read(win_lost_statistic_path).split("\n")

    #首先获取可能买的信号
    will_buy_array=[]

    potential_buy_contents.each do |line|
      result_array=JSON.parse(line.split("#")[1])
      will_buy_array<< line if result_array[1].to_i>=count && (result_array[3].to_f*100)>=already_win_percent #必须乘以100
    end
    if will_buy_array.size==0
     # puts "will_buy_array.size=#{will_buy_array.size}"
    return 
    end

  #puts "will_buy_array.size=#{will_buy_array.size}"
    buy_record_file=File.new(buy_record_path,"a+")

    will_buy_array.each do |line|
   # puts line
    result=line.split("#")
       # symbol=result[0]
    #signal_result=result[0].match(/\d+_\d+/).to_s

    signal_index=result[0].split("_")

    double_signal=signal_index[0].to_s+"_"+signal_index[1].to_s+"_"+raw_signal_on_date[signal_index[0].to_i].to_s.strip+raw_signal_on_date[signal_index[1].to_i].to_s.strip
     third_signal_index=signal_index[2].match(/\d+/).to_s
     third_signal_value=signal_index[2].split(/\d+/)[1]

     real_signal=double_signal+third_signal_index+third_signal_value

    if real_signal==result[0] #如果信号和发生次数多的相符合，那就是购买信号
      buy_record_file<<line+"\n"
     # break
    end
  end
  buy_record_file.close
if File.stat(buy_record_path).size==0
  File.delete(buy_record_path) 
end
end

def tripple_generate_future_buy_list(strategy,symbol)
  12.downto(1).each do |j|
  30.downto(1).each do |i|
    next unless Date.valid_date?(2013, j, -i)
    date = Date.new(2013, j, -i)

    unless (date.wday==6 || date.wday==0)
      puts date
      scan_signal_on_date_by_strategy_tripple(strategy,date,symbol) 
    end
  end
 end
end

end

if $0==__FILE__ 

  include StockBuyRecordTripple
 date="2013-11-13"
 start=Time.now
 strategy="hundun_1"
 symbol="000004.sz"
 generate_future_buy_list_tripple(strategy,symbol)

puts "cost time=#{Time.now-start}"

end