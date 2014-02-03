
require File.expand_path("../read_data_process.rb",__FILE__)
require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)

def high_price_signal(full_high_price_array,full_price_array,back_day)
	high_price_signal_hash=Hash.new

	high_price_array=full_high_price_array[back_day]
	price_array=full_price_array[back_day]
    #raise  if  high_price_array[1].nil?
    #raise  price_array if price_array[1][3].nil?

    high_price_signal_hash["highest_5_day"]= (high_price_array[1][4].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_10_day"]= (high_price_array[1][5].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_20_day"]= (high_price_array[1][6].to_f > price_array[1][3].to_f)
    high_price_signal_hash["highest_30_day"]= (high_price_array[1][7].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_60_day"]= (high_price_array[1][8].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_100_day"]= (high_price_array[1][9].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_120_day"]= (high_price_array[1][10].to_f > price_array[1][3].to_f) 
	return high_price_signal_hash
end

#用于产生每天的附加数据
def generate_high_price_signal_on_backday(high_price_array,full_price_array,back_day)
    high_price_signal_hash=Hash.new

    price_array=full_price_array[back_day]

    high_price_signal_hash["highest_5_day"]= (high_price_array[1][4].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_10_day"]= (high_price_array[1][5].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_20_day"]= (high_price_array[1][6].to_f > price_array[1][3].to_f)
    high_price_signal_hash["highest_30_day"]= (high_price_array[1][7].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_60_day"]= (high_price_array[1][8].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_100_day"]= (high_price_array[1][9].to_f > price_array[1][3].to_f) 
    high_price_signal_hash["highest_120_day"]= (high_price_array[1][10].to_f > price_array[1][3].to_f) 
    return high_price_signal_hash

end


def generate_all_high_price_signal(symbol)
	 #用于保存的Hash
	 full_high_signal_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_full_data_process_file(symbol)

     #获取完成的价格hash
     price_hash=get_price_hash_from_history(symbol)
     full_price_array=price_hash.to_a

     total_size=price_hash.size
     #puts full_price_array.size
     full_high_price_array=processed_data_array[2].to_a
     #puts full_high_price_array.size

     full_price_array.each_index do |index|
     	
       # next if index==total_size-1
     	date=full_price_array[index][0]
      
        signal_hash=high_price_signal(full_high_price_array,full_price_array,index)

        full_high_signal_hash[date]=signal_hash
     end

  full_high_signal_hash

end

if $0==__FILE__
   generate_all_high_price_signal("000009.sz")
end