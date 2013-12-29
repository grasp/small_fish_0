require File.expand_path("../read_data_process.rb",__FILE__)

def generate_open_signal(full_price_array,back_day)

	open_signal=Hash.new

	price_array= full_price_array[back_day]
	#print price_array

	open_signal["open_bigger_close"]  = (price_array[1][0].to_f > price_array[1][3].to_f) 
     #开盘价为最高价
	 open_signal["open_equal_high"]= (price_array[1][0].to_f == price_array[1][1].to_f) 
	 #开盘价为最低价
	 open_signal["open_equal_low"]= (price_array[1][0].to_f == price_array[1][2].to_f) 
     #收盘价为最低价
   	open_signal["close_equal_low"]= (price_array[1][3].to_f == price_array[1][2].to_f) 
     #收盘价为最高价
     open_signal["close_equal_high"]= (price_array[1][3].to_f == price_array[1][1].to_f)
     open_signal
end

def generate_all_open_signal(symbol)
     #用于保存的Hash
	 save_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_data_process_file(symbol)

     #获取完成的价格hash
     price_hash=processed_data_array[0]
     full_price_array=price_hash.to_a
     total_size=full_price_array.size

     full_price_array.each_index do |index|
     	date=full_price_array[index][0]
        next if index==total_size-1
        signal_hash=generate_open_signal(full_price_array,index)
        save_hash[date]=signal_hash
     end

     return  save_hash
end

if $0==__FILE__
 print	generate_all_open_signal("000009.sz")    
end