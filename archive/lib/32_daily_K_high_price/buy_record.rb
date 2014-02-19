require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require 'json'

def buy_record(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date,date)
	
	statistic_file=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/end_date_#{statistic_end_date}/all_statistic/all.txt",daily_k_path)
    statistic_hash=Hash.new 

    target_file_path=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/end_date_#{statistic_end_date}/percent_#{win_percent}_count_#{win_count}/buy_record/#{date}.txt",daily_k_path)
    lost_target_file_path=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/end_date_#{statistic_end_date}/percent_#{win_percent}_count_#{win_count}/buy_record/#{date}_lost.txt",daily_k_path)
    
    target_file=File.new(target_file_path,"w+")
    lost_target_file=File.new(lost_target_file_path,"w+")

    contents=File.read(statistic_file).split("\n")
   
    contents.each do |line|
      result=line.split("#")
      statistic_hash[result[0]]=result[1]
    end
     count=0
     $all_stock_list.keys.each do |symbol|
     	count+=1
       raw_file=File.expand_path("./history_daily_data/#{symbol}.txt",AppSettings.raw_data)
       next unless File.exists?(raw_file)
       price_hash=get_price_hash_from_history(symbol)
       next if price_hash.nil? || price_hash[date].nil?

      # puts "handle on symbol #{symbol},count=#{count}"
      # generate_daily_k_signal_on_date(price_hash,date)
       signal_on_date=generate_daily_k_signal_on_date(price_hash,date).to_s
     
       statistic_result=statistic_hash[signal_on_date]

       next if statistic_result.nil?
       result_array=JSON.parse(statistic_result)
        # puts "#{symbol} signal_on_date=#{signal_on_date},statistic_result=#{statistic_result}"
         target_file<<symbol+"#"+"#{statistic_result}"+"\n" if ((result_array[3].to_f*100)>win_percent && result_array[1].to_f>win_count)
         lost_target_file<<symbol+"#"+"#{statistic_result}"+"\n" if (((1-result_array[3].to_f)*100)>70 && result_array[2].to_f>20)
     end
     target_file.close
     lost_target_file.close

      if File.stat(target_file_path).size==0
        puts "no any buy record , delete file!!"  
        File.delete(target_file_path) 
     end
end

if $0==__FILE__
end