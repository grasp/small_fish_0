 require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
 require File.expand_path("../read_data_process.rb",__FILE__)
 require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)
#产生思路

def high_price_signal(full_high_price_array,full_price_array,back_day)
	return if full_price_array.size==0
	#puts "full size=#{full_high_price_array.size},full_price_array size=#{full_price_array.size}"
	high_price_signal_hash=Hash.new

	high_price_array=full_high_price_array[back_day]
	price_array=full_price_array[back_day]
    #raise  if  high_price_array[1].nil?
    #raise  price_array if price_array[1][3].nil?
  # 这里逻辑是否正确？
  #  high_price_signal_hash["highest_5_day"]= (high_price_array[1][4].to_f > price_array[1][3].to_f) 
   # high_price_signal_hash["highest_10_day"]= (high_price_array[1][5].to_f > price_array[1][3].to_f) 
  #  high_price_signal_hash["highest_20_day"]= (high_price_array[1][6].to_f > price_array[1][3].to_f)
  #  high_price_signal_hash["highest_30_day"]= (high_price_array[1][7].to_f > price_array[1][3].to_f) 
  #  high_price_signal_hash["highest_60_day"]= (high_price_array[1][8].to_f > price_array[1][3].to_f) 
  #  high_price_signal_hash["highest_100_day"]= (high_price_array[1][9].to_f > price_array[1][3].to_f) 
  #  high_price_signal_hash["highest_120_day"]= (high_price_array[1][10].to_f > price_array[1][3].to_f) 
    return {} if high_price_array.nil? || high_price_array[1].nil?
    high_price_signal_hash["highest_3_day"]= (high_price_array[1][2].to_f <= price_array[1][3].to_f) 
    high_price_signal_hash["highest_4_day"]= (high_price_array[1][3].to_f <= price_array[1][3].to_f) 
    high_price_signal_hash["highest_5_day"]= (high_price_array[1][4].to_f <= price_array[1][3].to_f) 
    high_price_signal_hash["highest_10_day"]= (high_price_array[1][5].to_f <= price_array[1][3].to_f) 
    high_price_signal_hash["highest_20_day"]= (high_price_array[1][6].to_f <= price_array[1][3].to_f)
    high_price_signal_hash["highest_30_day"]= (high_price_array[1][7].to_f <= price_array[1][3].to_f) 
    high_price_signal_hash["highest_60_day"]= (high_price_array[1][8].to_f <= price_array[1][3].to_f) 
    high_price_signal_hash["highest_100_day"]= (high_price_array[1][9].to_f <= price_array[1][3].to_f) 
    high_price_signal_hash["highest_120_day"]= (high_price_array[1][10].to_f <= price_array[1][3].to_f) 
	return high_price_signal_hash
end

def init_generate_high_price_signal
	signal_array=["highest_3_day","highest_4_day","highest_5_day","highest_10_day","highest_20_day","highest_30_day","highest_60_day","highest_100_day","highest_120_day"]
    signal_array.each do |signal_name|
    	signal_path=File.expand_path("./#{signal_name}",AppSettings.single_signal)
    	Dir.mkdir(signal_path) unless File.exists?(signal_path)    	
    end
end


def generate_high_price_signal_for_one_symbol(symbol,regenerate_flag)

	signal_array=["highest_3_day","highest_4_day","highest_5_day","highest_10_day","highest_20_day","highest_30_day","highest_60_day","highest_100_day","highest_120_day"]
	file_hash=Hash.new

	signal_array.each do |signal_name|
		expected_file=File.expand_path("./#{signal_name}/#{symbol}.txt",AppSettings.single_signal)
		if File.exists?(expected_file)
			if regenerate_flag==false
			# puts "#{symbol} exists, return"
			 return
			end
		end
	end

	signal_array.each do |signal_name|
		file_hash[signal_name]=File.new(File.expand_path("./#{signal_name}/#{symbol}.txt",AppSettings.single_signal),"w+")
	end

	 #用于保存的Hash
	 full_high_signal_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_full_data_process_file(symbol)

     #获取完成的价格hash
     price_hash=get_price_hash_from_history(symbol)
     full_price_array=price_hash.to_a
     return if full_price_array.size==0

     total_size=price_hash.size
     #puts full_price_array.size
     full_high_price_array=processed_data_array[2].to_a
     #puts full_high_price_array.size

     full_price_array.each_index do |index|     	
       next if index==total_size-1
       date=full_price_array[index][0]      
       signal_hash=high_price_signal(full_high_price_array,full_price_array,index)
        #puts signal_hash
       signal_hash.each do |signal_name,value|
       file_hash[signal_name]<<"#{date}##{value}\n"
       end
       # full_high_signal_hash[date]=signal_hash
     end

     signal_array.each do |signal_name|
		file_hash[signal_name].close
	end

  #full_high_signal_hash

end


def generate_high_price_signal_for_all_symbol(regenerate_flag)
   count=0
   init_generate_high_price_signal
	$all_stock_list.keys.each do |symbol|
		puts "#{symbol},#{count}"
		generate_high_price_signal_for_one_symbol(symbol,regenerate_flag)
		count+=1
	end

end

if $0==__FILE__
	start=Time.now
 #  generate_high_price_signal_for_one_symbol("000009.sz",true)
   generate_high_price_signal_for_all_symbol(true)
   puts "cost time=#{Time.now-start}"
end