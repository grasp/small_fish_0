 require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
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

def init_open_signal
    signal_array=["open_bigger_close","open_equal_high","open_equal_low","close_equal_low","close_equal_high"]
        signal_array.each do |signal_name|
        signal_path=File.expand_path("./#{signal_name}",AppSettings.single_signal)
        Dir.mkdir(signal_path) unless File.exists?(signal_path)     
    end
end

def generate_open_signal_for_one_symbol(symbol,regenerate_flag)

    signal_array=["open_bigger_close","open_equal_high","open_equal_low","close_equal_low","close_equal_high"]
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
	 save_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_full_data_process_file(symbol)

     #获取完成的价格hash
     price_hash=processed_data_array[0]
     full_price_array=price_hash.to_a
     total_size=full_price_array.size

     full_price_array.each_index do |index|
     	date=full_price_array[index][0]
        next if index==total_size-1
        signal_hash=generate_open_signal(full_price_array,index)
       # save_hash[date]=signal_hash
       signal_hash.each do |signal_name,value|
         file_hash[signal_name]<<"#{date}##{value}\n"
       end

     end

      signal_array.each do |signal_name|
          file_hash[signal_name].close
       end

end

def generate_open_signal_for_all_symbol(regenerate_flag)
       count=0
    init_open_signal
    $all_stock_list.keys.each do |symbol|
        puts "#{symbol},#{count}"
        generate_open_signal_for_one_symbol(symbol,regenerate_flag)
        count+=1
    end
end

if $0==__FILE__
 generate_open_signal_for_all_symbol(true)  
end