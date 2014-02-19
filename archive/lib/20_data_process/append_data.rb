require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../low_high_price_history.rb",__FILE__)
require File.expand_path("../macd_history.rb",__FILE__)
require File.expand_path("../volume_history.rb",__FILE__)

# 初次计算的值附加
def append_processed_data(symbol,price_array,back_day_array)

  processed_data_path=File.expand_path("#{symbol}.txt",$data_process_path)
 # puts "#{processed_data_path}"
  processed_data_file=File.new(processed_data_path,"a+")

  back_day_array.reverse.each do |back_day|
   # puts "handle backday=#{back_day},day_zero=#{price_array[0][0]}"
    low_high=low_high_price_array_on_backdays(price_array,back_day)

    low_price_array=low_high[0]
    high_price_array=low_high[1]

    result_macd_array=generate_macd_on_backday(price_array,back_day)
    volume_array=generate_volume_array_on_backday(price_array,back_day)

    date=price_array[back_day][0]
     # puts "price_array[back_day]=#{price_array[back_day]}"
    #puts "handle date=#{date}"
    #如果已经附加过了，就不要再附加了TBD

    processed_data_file<<date.to_s
    processed_data_file<<"#"+result_macd_array.to_s
    processed_data_file<<"#"+low_price_array.to_s
    processed_data_file<<"#"+high_price_array.to_s
    processed_data_file<<"#"+volume_array.to_s     
    processed_data_file<<"\n"

end
    processed_data_file.close
end



def get_diff_date(price_array,symbol)

  processed_data_path=File.expand_path("#{symbol}.txt",$data_process_path)

  contents=File.read(processed_data_path).split("\n")
  last_date= contents.last.match(/\d\d\d\d-\d\d-\d\d/).to_s
 # puts "last_date=#{last_date}"
  back_day_array=[]

  0.upto(price_array.size).each do |index|
    # puts "price_array[index][0]=#{price_array[index]}"
    next if price_array[index].nil?
    #已经最新了，就不进行更行
   
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

def append_diff_data(strategy,symbol)
  price_hash=get_price_hash_from_history(strategy,symbol)
  price_array=price_hash.to_a

 # puts "#{price_array.size}"

  back_day_array=get_diff_date(price_array,symbol)

  append_processed_data(symbol,price_array,back_day_array)

end

def append_all_data_process(strategy)
    count=0
    #$logger.info("start append all data process")

    $all_stock_list.keys.each do |symbol|
     target_file=File.expand_path("#{symbol}.txt",$data_process_path)
     next unless File.exists?(target_file) #如果原来没有存在，附加就会失败TBD
     count+=1
     puts "append #{symbol},count=#{count}"
        # price_hash=get_price_hash_from_history(symbol)
         append_diff_data(strategy,symbol)
    end
  #  $logger.info("end append all data process")
end


if $0==__FILE__

	symbol="000009.sz"
	#price_hash=get_price_hash_from_history("000009.sz")

	#append first day data 
  #  append_processed_data("000009.sz",price_hash,0)

#get_diff_date(symbol)
#append_diff_data(symbol)
#  append_all_data
end