require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../utility/read_raw_data_process.rb",__FILE__)

module StockSignal
    include StockUtility

def low_price_signal(full_low_price_array,full_price_array,back_day)
	low_price_signal_hash=Hash.new
    #puts "low back_day=#{back_day},#{full_low_price_array.size}=#{full_price_array.size}"
    if back_day >= full_low_price_array.size
    return 
    end
	low_price_array=full_low_price_array[back_day]
	price_array=full_price_array[back_day]

    #puts "back_day=#{back_day},#{full_low_price_array.size},#{full_price_array.size}"
	#print low_price_array.to_s+"\n"
	#print "price_array="+price_array.to_s+"\n"
    low_price_signal_hash["lowest_2_day"]= (low_price_array[1][1].to_f >= price_array[1][3].to_f)
    low_price_signal_hash["lowest_3_day"]= (low_price_array[1][2].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_4_day"]= (low_price_array[1][3].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_5_day"]= (low_price_array[1][4].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_10_day"]= (low_price_array[1][5].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_20_day"]= (low_price_array[1][6].to_f >= price_array[1][3].to_f)
    low_price_signal_hash["lowest_30_day"]= (low_price_array[1][7].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_60_day"]= (low_price_array[1][8].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_100_day"]= (low_price_array[1][9].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_120_day"]= (low_price_array[1][10].to_f >= price_array[1][3].to_f) 
	return low_price_signal_hash
end

def generate_low_price_signal_on_backday(low_price_array,full_price_array, back_day)

    low_price_signal_hash=Hash.new

    price_array=full_price_array[back_day]
    low_price_signal_hash["lowest_3_day"]= (low_price_array[1][2].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_4_day"]= (low_price_array[1][3].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_5_day"]= (low_price_array[1][4].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_10_day"]= (low_price_array[1][5].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_20_day"]= (low_price_array[1][6].to_f >= price_array[1][3].to_f)
    low_price_signal_hash["lowest_30_day"]= (low_price_array[1][7].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_60_day"]= (low_price_array[1][8].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_100_day"]= (low_price_array[1][9].to_f >= price_array[1][3].to_f) 
    low_price_signal_hash["lowest_120_day"]= (low_price_array[1][10].to_f >= price_array[1][3].to_f) 
    return low_price_signal_hash
end


def generate_all_low_price_signal(strategy,symbol)
	 #用于保存的Hash
	 save_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_full_data_process_file(strategy,symbol)

     #获取完成的价格hash
      price_hash=get_price_hash_from_history(strategy,symbol)
      full_price_array=price_hash.to_a.reverse

     #print full_price_array
     low_price_hash=processed_data_array[1]
    # puts low_price_hash
     full_low_price_array=low_price_hash.to_a
    # print "back day 0 ="+full_low_price_array[0][0].to_s
     total_size=full_low_price_array.size

     #print full_low_price_array[0..10]
    # puts "  "
    # print full_price_array[0..10]

     full_low_price_array.each_index do |index|
     	#  next if index==total_size-1
     	 # print "index=#{index}"
     	#puts "index#{index}="+full_low_price_array[index].to_s
     	date=full_low_price_array[index][0]
  
       # puts "date=#{date}"
        signal_hash=low_price_signal(full_low_price_array,full_price_array,index)
       # print signal_hash
        save_hash[date]=signal_hash
     end
#puts save_hash
save_hash
end
end

if $0==__FILE__
  include StockSignal
  strategy="hundun_1"
  generate_all_low_price_signal(strategy,"000981.sz")
end 