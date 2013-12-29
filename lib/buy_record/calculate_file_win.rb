require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../30_signal_gen/price_will_up_down_signal.rb",__FILE__)

def calculate_file_win_with_close(will_key,date,percent,count)

  file=File.expand_path("./buy_record/#{will_key}/#{date}_percent_#{percent}_count_#{count}.txt","#{AppSettings.resource_path}")
  
  #date=file.match(/\d\d\d\d-\d\d-\d\d/).to_s
 # will_key="up_p10_after_3_day"
  #puts date
  contents=File.read(file).split("\n")
  #puts contents
  true_counter=0
  false_counter=0
  contents.each do |symbol|
  #	puts symbol
    price_hash=get_price_hash_from_history(symbol)
    price_array=price_hash.to_a
    back_day=0

    price_array.each_index do |index|
     # puts "index=#{index}"
    	#price_array[index][0]puts price_array[index][0]

    	if price_array[index][0]==date

          back_day=index
         # puts "back_day=#{back_day}"	
          break
         end         
    end

   if generate_price_will_up_down(price_hash,back_day)[will_key]==true
      true_counter+=1
    else
      false_counter+=1
    end       
  end

   puts "percent on #{date} = #{true_counter.to_f/(true_counter+false_counter)}"

end

if $0==__FILE__
	start=Time.now
	#file=File.expand_path("./buy_record/up_p10_after_3_day/2013-10-24_percent_95_count_10.txt","#{AppSettings.resource_path}")
#	all_date=["2013-09-11","2013-09-12","2013-09-13","2013-09-16","2013-09-17","2013-09-18","2013-09-23","2013-09-24","2013-09-25","2013-09-26","2013-09-27","2013-09-30","2013-10-08","2013-10-09","2013-10-10","2013-10-11","2013-10-14","2013-10-15","2013-10-16","2013-10-17","2013-10-18","2013-10-21"]
	#all_date.each do |date|
  date="2013-11-12"
	  calculate_file_win_with_close("up_p10_after_3_day",date,95,10)
 #   end
	puts "cost=#{Time.now-start}"
end