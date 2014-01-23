require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../macd_signal.rb",__FILE__)
require File.expand_path("../low_price_signal.rb",__FILE__)
require File.expand_path("../high_price_signal.rb",__FILE__)
require File.expand_path("../open_signal.rb",__FILE__)
require File.expand_path("../volume_signal.rb",__FILE__)
require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)


#back day 0表示最新的一天
def append_signal_on_back_day_array(strategy,symbol,price_array,back_day_array)

   signal_file_path=File.expand_path("#{symbol}.txt",$signal_path)
   signal_file=File.new(signal_file_path,"a+")

	processed_data=File.expand_path("#{symbol}.txt",$data_process_path)

back_day_array.reverse.each do |back_day|
    contents_array=File.read(processed_data).split("\n").reverse
 
    price_hash=get_price_hash_from_history(strategy,symbol)
    price_array=price_hash.to_a

    date=price_array[back_day][0]

    #print full_price_array[0]

   # puts "full_price_array[0]=#{date}"

    result_data=contents_array[back_day].split("#")
    t_macd_array=result_data[1].gsub(/\[|\]/,"").split(",")
    last_macd_array=contents_array[back_day+1].split("#")[1].gsub(/\[|\]/,"").split(",")

    #print  t_macd_array
   # print last_macd_array

    low_price_array=result_data[2].gsub(/\[|\]/,"").split(",")
    high_price_array=result_data[3].gsub(/\[|\]/,"").split(",")
    volume_array=result_data[4].gsub(/\[|\]/,"").split(",")

    macd_signal_hash=judge_macd_signal(t_macd_array,last_macd_array,back_day)
	  high_price_signal_hash=generate_high_price_signal_on_backday(high_price_array,price_array,back_day)
    low_price_signal_hash=generate_low_price_signal_on_backday(low_price_array,price_array,back_day)
    volume_signal_hash=generate_volume_signal_on_backday(volume_array,back_day)
    open_signal=generate_open_signal(price_array,back_day)

#这个顺序必须和save all signal里面的一样，否则就乱套了
    result_hash=macd_signal_hash.merge(low_price_signal_hash).merge(high_price_signal_hash).merge(volume_signal_hash).merge(open_signal)


#加入到文件中

   signal_file<<date.to_s+"#"+result_hash.values.to_s+"\n"
 end
   signal_file.close

end

def get_diff_date_signal(price_array,symbol)

  processed_data_path=File.expand_path("#{symbol}.txt",$signal_path)

  contents=File.read(processed_data_path).split("\n")
  last_date= contents.last.match(/\d\d\d\d-\d\d-\d\d/).to_s
  back_day_array=[]

  0.upto(price_array.size).each do |index|
    next if price_array[index].nil?
    if price_array[index][0]==last_date
      break
    else
      back_day_array<<index
     # price_array[index][0]
    end
end
#print  "back_day_array=#{back_day_array}"
back_day_array
end

def append_all_signal(strategy)
    count=0
    $logger.info("start append all signal")
    $all_stock_list.keys.each do |symbol|
        count+=1
     data_path=File.expand_path("#{symbol}.txt",$signal_path)
     if File.exists?(data_path)
    price_hash=get_price_hash_from_history(strategy,symbol)
    back_day_array=get_diff_date_signal(price_hash.to_a,symbol)
    append_signal_on_back_day_array(strategy,symbol,price_hash.to_a,back_day_array)
    puts "#{symbol},count=#{count}"
end
    end
     $logger.info("end append all signal")
end


if $0==__FILE__
    symbol="000009.sz"

    #获取完成的价格hash
   # price_hash=get_price_hash_from_history(symbol)
	 #back_day_array=get_diff_date_signal(price_hash.to_a,symbol)
    #append_signal_on_back_day_array(symbol,price_hash.to_a,back_day_array)
    append_all_signal
end