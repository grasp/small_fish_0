#require File.expand_path("../macd_signal.rb",__FILE__)
#require File.expand_path("../low_price_signal.rb",__FILE__)
#require File.expand_path("../high_price_signal.rb",__FILE__)
#require File.expand_path("../open_signal.rb",__FILE__)
#require File.expand_path("../volume_signal.rb",__FILE__)
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../utility/read_raw_data_process.rb",__FILE__)

module StockSignal
    include StockUtility
def generate_volume_signal_on_backday(strategy,volume_array, back_day)
     
	 volume_signal=Hash.new
     volume_signal["volume1_bigger_volume2"]=(volume_array[0].to_f > volume_array[1].to_f) 
     volume_signal["volume2_bigger_volume3"]=(volume_array[1].to_f > volume_array[2].to_f) 
     volume_signal["volume2_bigger_volume5"]=(volume_array[1].to_f > volume_array[4].to_f) 
  	 volume_signal["volume5_bigger_volume10"]= (volume_array[4].to_f > volume_array[5].to_f) 
     volume_signal["volume5_bigger_volume20"]= (volume_array[4].to_f > volume_array[6].to_f) 
     volume_signal["volume5_bigger_volume30"]= (volume_array[4].to_f > volume_array[7].to_f) 
     volume_signal["volume5_bigger_volume60"]= (volume_array[4].to_f > volume_array[8].to_f) 
     volume_signal["volume5_bigger_volume100"]= (volume_array[4].to_f > volume_array[9].to_f) 
     return volume_signal
end

def generate_volume_sigmal_by_full(strategy,full_volume_array,back_day)
     volume_array=full_volume_array[back_day][1]
     return generate_volume_signal_on_backday(strategy,volume_array, back_day)
end

#产生一个以日期为key,各个信号的值以hash保存的Hash
def generate_full_volume_signal(strategy,symbol)
	 #用于保存的Hash
	 save_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_full_data_process_file(strategy,symbol)

     #获取完成的价格hash
     price_hash=get_price_hash_from_history(strategy,symbol)
     full_price_array=price_hash.to_a


     full_volume_array=processed_data_array[3].to_a

     print  full_volume_array.size

    # raise
    # print "back day 0 ="+full_low_price_array[0][0].to_s
     total_size=full_volume_array.size

     full_price_array.each_index do |index|
     #	next if index==total_size-1
     	date=full_price_array[index][0]      
        signal_hash=generate_volume_sigmal_by_full(strategy,full_volume_array,index)
        save_hash[date]=signal_hash
     end
#puts save_hash
save_hash
end
end

if $0==__FILE__
    include StockSignal
    generate_full_volume_signal("hundun_1","000004.sz")
end