 require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../read_data_process.rb",__FILE__)
require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)

def low_price_signal(full_low_price_array,full_price_array,back_day)

    return if full_price_array.size==0
	low_price_signal_hash=Hash.new
	low_price_array=full_low_price_array[back_day]
	price_array=full_price_array[back_day]

    return {} if low_price_array.nil? || low_price_array[1].nil?||price_array.nil?
	#print low_price_array.to_s+"\n"
	#print "price_array="+price_array.to_s+"\n"
    low_price_signal_hash["lowest_3_day"]= (low_price_array[1][2].to_f >= price_array[1][2].to_f) 
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

def init_low_price_signal
    signal_array=["lowest_3_day","lowest_4_day","lowest_5_day","lowest_10_day","lowest_20_day","lowest_30_day","lowest_60_day","lowest_100_day","lowest_120_day"]
    signal_array.each do |signal_name|
        signal_path=File.expand_path("./#{signal_name}",AppSettings.single_signal)
        Dir.mkdir(signal_path) unless File.exists?(signal_path)     
    end
end

def generate_low_price_signal_for_one_symbol(symbol,regeneration_flag)

    signal_array=["lowest_3_day","lowest_4_day","lowest_5_day","lowest_10_day","lowest_20_day","lowest_30_day","lowest_60_day","lowest_100_day","lowest_120_day"]
    file_hash=Hash.new

    signal_array.each do |signal_name|
        expected_file=File.expand_path("./#{signal_name}/#{symbol}.txt",AppSettings.single_signal)
        if File.exists?(expected_file)
            if regeneration_flag==false
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
      price_hash=get_price_hash_from_history(symbol)
      full_price_array=price_hash.to_a

     #print full_price_array
     low_price_hash=processed_data_array[1]
     full_low_price_array=low_price_hash.to_a
     total_size=full_low_price_array.size

     full_low_price_array.each_index do |index|
        next if index==total_size-1
     	date=full_low_price_array[index][0]
      
        signal_hash=low_price_signal(full_low_price_array,full_price_array,index)
        signal_hash.each do |signal_name,value|
          file_hash[signal_name]<<"#{date}##{value}\n"
        end

     end

     signal_array.each do |signal_name|
        file_hash[signal_name].close
    end
end


def generate_low_price_signal_for_all_symbol(regeneration_flag)
    count=0
    init_low_price_signal
    $all_stock_list.keys.each do |symbol|
        puts "#{symbol},#{count}"
        generate_low_price_signal_for_one_symbol(symbol,regeneration_flag)
        count+=1
    end
end
if $0==__FILE__
  init_low_price_signal
 # generate_low_price_signal_for_one_symbol("000009.sz",true)
  generate_low_price_signal_for_all_symbol(true)
end