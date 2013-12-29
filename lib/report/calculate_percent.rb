require File.expand_path("../get_history_percent.rb",__FILE__)
require File.expand_path("../../signal_process/cal_common.rb",__FILE__)
require File.expand_path("../../signal_process/get_zuhe.rb",__FILE__)
require File.expand_path("../../signal_process/read_signal_process.rb",__FILE__)
require File.expand_path("../../data_process/read_daily_k.rb",__FILE__)

def calculate_percent(symbol,day_signal,date,history_percent_hash,is_up)

index_array=get_all_possible_zuhe2(day_signal.size)
   

#win_percent=0
#lost_percent=0
#history_percent_hash.each do |key,value|
# value_array=value.gsub(/\[|\]/,"").split(",")
# win_percent+=(value_array[1].to_f)*(value_array[3].to_f)
# lost_percent+=(value_array[2].to_f)*(value_array[4].to_f)	
#end

#print history_percent_hash.keys
#puts "win_percent=#{win_percent},lost_percent=#{lost_percent},win percent=#{cal_per(win_percent,lost_percent)}"
win_percent=0
lost_percent=0
index_counter=0
index_array.each do |index|
	index_counter+=1
	new_array=[[index[0].to_s,index[1].to_s]]
	new_array<<day_signal[index[0]].to_s
	new_array<<day_signal[index[1]].to_s
  #  print new_array
   value_array= history_percent_hash[new_array].gsub(/\[|\]/,"").split(",")
    win_percent+=(value_array[3].to_f)
   lost_percent+=(value_array[4].to_f)	
end

record_file=File.new("guess_result.txt","a+")
 #{}"win_percent=#{win_percent},lost_percent=#{lost_percent},win percent=#{cal_per(win_percent,lost_percent)}"
#record_file<< date+"win_percent=#{win_percent},lost_percent=#{lost_percent},win percent=#{cal_per(win_percent,lost_percent)}"
record_file<< date+"win percent=#{cal_per(win_percent,lost_percent)}"+"  #{is_up}"+"\n"
record_file.close
end

if $0==__FILE__

	result = read_signal_process("000009.sz")
	raw_hash=read_daily_k_file("000009.sz")
	history_percent_hash=get_history_percent("000009.sz")
	raw_array=raw_hash.to_a

	result[1].each_index do |index|
    puts "index#{index}=#{raw_array[index][0]}"
    if index>3
    	today=raw_array[index][1][3].to_f
    	tommorrow=raw_array[index-1][1][3]
    	next_tommorrow=raw_array[index-2][1][3]
    	next_next_tommorrow=raw_array[index-3][1][3]
   # guess= (raw_array[index-1][1][3].to_f>raw_array[index][1][3].to_f) || (raw_array[index-2][1][3].to_f>raw_array[index][1][3].to_f) || (raw_array[index-3][1][3].to_f>raw_array[index][1][3].to_f)
   guess= (((tommorrow-today)/today)>0.03) ||(((next_tommorrow-today)/today)>0.03) || (((next_next_tommorrow-today)/today)>0.03)
    else
    guess=true
     end
	#day_signal=[false, false, false, false, false, false, true, true, true, true, false, false, true, true, true, false, false, true, true, false, false, true, true, false, true, true, true, true, true, true, false, false, false, false, false, true, true, true, true, true, false, true, true, true, false, false, true, true, false, false, true, true, false, true, true, true, true, true, false, false, false, false, false, false, false, true, true, true, true, false, false, false, false, false, false, false, true, true, true, true, true, true, true, false, true, true, false, false, false, false, false, false, false, false, false, false]
   #day_signal=[true, false, false, false, false, false, true, true, true, true, true, false, true, true, false, false, false, true, true, false, false, true, true, false, true, true, true, true, true, true, false, false, false, false, false, true, true, true, true, true, false, true, true, false, false, false, true, true, false, false, true, true, false, true, true, true, true, true, true, true, true, true, false, true, false, true, true, true, true, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, false, false, false, false, false, true, false, false, false, false]
    
    calculate_percent("000009.sz",result[1][index],raw_array[index][0],history_percent_hash,guess)
end
end