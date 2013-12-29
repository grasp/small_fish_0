require File.expand_path("../../signal_process/split_signal_into_win_lost.rb",__FILE__)

def read_signal_process_result(symbol,will_key)

	signal_process_path=File.expand_path("./signal_process/two/#{will_key}/#{symbol}.txt","#{AppSettings.resource_path}")
    puts "signal_process_path=#{signal_process_path}"
	signal_process=File.read(signal_process_path).split("\n")
	signal_process_array=[]
	signal_process.each_index do |index|
		result= signal_process[index].split("#")
	    result[6]=result[6].gsub(/\[|\]/,"").split(",")#.to_s+"\n"
	    #signal_process_hash[index]=result
	    signal_process_array<<result
	end
  sort_file=File.new("sort_reuslt.txt","w+")
  sorted_percent_array=signal_process_array.sort_by {|x| x[6][1].to_i}.reverse
	 sorted_percent_array.each do |line|        
	 	sort_file<<line.to_s+"\n"
end
		sort_file.close

  # 现在加入其他信号来比较
#[signal_keys,win_signal_array,win_lost_array]
  #split_signal_by_will_key(symbol,will_key)

end

def calculate_win_percent(signal1_index,signal2_index,signal1_value,signal2_value,signal3_index,win_array,lost_array)
	win_signal3_true_count=0
	win_signal3_false_count=0
	loss_signal3_true_count=0
	loss_signal3_false_count=0

    win_array.each do |array|
    	if array[signal1_index]==signal1_value &&  array[signal2_index]==signal2_value
    		array[signal3_index]==true ? win_signal3_true_count+=1 : win_signal3_false_count+=1
    	end
    end

    loss_array.each do |array|
      if array[signal1_index]==signal1_value &&  array[signal2_index]==signal2_value
    	array[signal3_index]==true ? loss_signal3_true_count+=1 : loss_signal3_false_count+=1
      end
    end
end

if $0==__FILE__
    start=Time.now
	symbol="000009.sz"
	read_signal_process_result(symbol,"up_p10_after_3_day")
    puts "cost=#{Time.now-start}"
end