
require  File.expand_path("../../signal_process/read_generated_signal.rb",__FILE__)
require  File.expand_path("../read_processed_signal.rb",__FILE__)
require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)

def buy_by_up_p10_after_several_days

end


def buy_on_date(date,will_key,win_percent,win_count)
    count=0
     buy_record=File.new(File.expand_path("./buy_record/#{will_key}/#{date}_percent_#{win_percent}_count_#{win_count}.txt","#{AppSettings.resource_path}"),"w+")

    $all_stock_list.keys.each do |stock_id|
      puts "handle on #{stock_id}"
 
      signal_file_path=File.expand_path("./signal/#{stock_id}.txt","#{AppSettings.resource_path}")
      signal_process_path=File.expand_path("./signal_process/two/#{will_key}/#{stock_id}.txt","#{AppSettings.resource_path}")

      if File.exists?(signal_file_path)  && File.exists?(signal_process_path)
        # print stock_id
        signal_array=read_signal_gen(stock_id)[1][date]
  
        win_array=read_processed_signal(stock_id,will_key,win_percent,win_count)

        puts "#{stock_id} is nil" if signal_array.nil?
        next if signal_array.nil?
        win_array.each do |array|
          index_1=array[0].to_i
          index_2=array[1].to_i
         # print "signal_array[index_1]=#{signal_array[index_1]},array[2]=#{array[2]}\n"
         # print "signal_array[index_2]=#{signal_array[index_2]},array[3]=#{array[3]}\n"
           if signal_array[index_1].to_s==array[2] && signal_array[index_2].to_s==array[3]
             buy_record << stock_id+"\n"
             puts "got buy chance on #{stock_id} on #{date}" 
             break
           end
        end
         else
         # puts "ignore #{stock_id}"
     end

   end
        buy_record.close
end

if $0==__FILE__
    start=Time.now
    will_key="up_p10_after_3_day"
   date="2013-11-19"
    index_symbol="000009.sz"
    price_hash=get_price_hash_from_history(index_symbol)
    price_array=price_hash.to_a

    win_percent=95
    win_count=10
   # price_array[9..30].each do |array|
    #  puts array[0]
     buy_on_date(date,will_key,win_percent,win_count)
   # end
    puts "cost=#{Time.now-start}"
end