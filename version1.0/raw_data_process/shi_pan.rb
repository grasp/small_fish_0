require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/get_last_date.rb",__FILE__)
require File.expand_path("../generate_history_raw_data_process.rb",__FILE__)
require 'net/http' 
require 'ostruct' 

include StockRawDataProcess
def append_raw_process_data(strategy,symbol)

	#get the gap of the raw_process_data
	last_raw_data=get_last_date_of_raw_date(strategy,symbol)
	last_raw_process_date=get_last_date_of_raw_process_date(strategy,symbol)
  
  ##############################################
  #如果是最新的，就不做任何处理
    today=Time.now.to_s[0..9]
   #puts "last date=#{last_date},today=#{today}"
   raw_process_gap_date_array=get_gap_date_array(last_raw_process_date,today)

   # 如果没有gap，那就不做处理
   if raw_process_gap_date_array.size==0
    puts "#{symbol} already latest!"
     return 
   else
    puts "gap_date_array size =#{raw_process_gap_date_array.size}"
   end

###############################################

   #puts "last date=#{last_date},today=#{today}"
   raw_data_gap_date_array=get_gap_date_array(last_raw_data,today)

   #如果gap 一样，说明raw data没有准备好， 也不需要更新
   return if raw_data_gap_date_array==raw_process_gap_date_array

######################################################
if raw_process_gap_date_array.size>raw_data_gap_date_array.size
	puts " need append!"
	raw_process_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data_process,"#{symbol}.txt")
	append_file=File.new(raw_process_file,"a+")

    append_date_array=raw_process_gap_date_array-raw_data_gap_date_array

	price_hash=get_price_hash_from_history(strategy,symbol)
    price_array=price_hash.to_a.reverse

    append_date_array.each do |append_date|
    	next if append_date[1]=="false"
    	back_day=0
    	price_array.each_index do |index|
    	# print "#{price_array[index][0]},#{append_date[0]}\n"	
    	if price_array[index][0]==append_date[0]
    		puts "index=#{index}"
    		back_day==index
    	end
          low_high=low_high_price_array_on_backdays(price_array,back_day)
          low_price_array=low_high[0]
          high_price_array=low_high[1]

          result_macd_array=generate_macd_on_backday(price_array,back_day)
          volume_array=generate_volume_array_on_backday(price_array,back_day)

          date=price_array[back_day][0]

          append_file<<date.to_s
          append_file<<"#"+result_macd_array.to_s
          append_file<<"#"+low_price_array.to_s
          append_file<<"#"+high_price_array.to_s
          append_file<<"#"+volume_array.to_s     
          append_file<<"\n"
        end
    end

   # print price_array
   append_file.close
end


end

if $0==__FILE__
	strategy="hundun_1"
	symbol="000005.sz"
	append_raw_process_data(strategy,symbol)
end