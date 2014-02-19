require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require 'json'

def generate_win_lost_counter()
	win_lost=File.expand_path("./win_lost","#{AppSettings.resource_path}")
	Dir.new(win_lost).each do |folder|
      puts folder
	end
end

#统计输赢的信号比例
def generate_counter_for_percent(symbol,folder,stragety)
    #folder="percent_3_num_3_days"
    signal_file=File.expand_path("./#{symbol}.txt",$signal_path)
    win_lost_file=File.expand_path("./#{folder}/#{symbol}.txt",$win_lost_path)

    win_lost_array=File.read(win_lost_file).split("\n")
    win_lost_hash=Hash.new
    signal_hash=Hash.new

    win_lost_array.each do |line|
    	result=line.split("#")
    	win_lost_hash[result[0]]=result[1]
    end
    
   # print win_lost_hash
   signal_array=File.read(signal_file).split("\n")
   first_line=signal_array.shift(1)[0]
   signal_keys=JSON.parse(first_line)

   #puts signal_keys
   signal_array.each do |line|
    result=line.split("#")
    temp=JSON.parse(result[1])
   temp.each_index do |index|
    	temp[index]=temp[index].to_s
    end
    signal_hash[result[0]]=temp
   end

ori_array_size=signal_keys.size
 iter_array=(0..(ori_array_size-1)).to_a  
 possible_zuhe=[]
 total_size=ori_array_size

iter_array.each do |cycle|
 iter_array[cycle].upto(total_size-1).each do |i|
 	possible_zuhe<<[cycle,i]
 end
end

count=0
win_hash=Hash.new{0}
lost_hash=Hash.new{0}

possible_zuhe.each do |zuhe|
	a=zuhe[0]
	b=zuhe[1]
  c=zuhe[0].to_s
  d=zuhe[1].to_s
win_lost_hash.each do |date,w_l|
signal_array=signal_hash[date].values_at(a,b)

	key=""
	key<<c<<"_"<<d<<signal_array[0]<<signal_array[1]
	w_l=="true" ? win_hash[key]+=1 : lost_hash[key]+=1
	
end
end
total_hash=Hash.new

win_hash.each do |key,value|
	if lost_hash.has_key?(key)
      total_hash[key]=[value,lost_hash[key]]
	else
     total_hash[key]=[value,0]
	end
end

lost_hash.each do |key,value|
	unless win_hash.has_key?(key)
     total_hash[key]=[0,value]
	end
end
total_hash.each do |key,value|
	total=value[0]+value[1]
	total_hash[key]=[total,value[0],value[1],(value[0]/total.to_f)]
end

win_lost_statistic=File.expand_path("./#{folder}/#{symbol}.txt",$end_date_path)
s_file= File.new(win_lost_statistic,"w+")

  total_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|

  s_file<<key.to_s+"#"+value.to_s+"\n"
end
s_file.close

end


def generate_all_win_lost(stragety)
    #folder="percent_1_num_1_days"
    folder=AppSettings.send(stragety).win_expect
  counter=0
  percent_folder=$win_expect
  #Dir.mkdir(percent_folder) unless File.exists?(percent_folder)
	$all_stock_list.keys.each do |symbol|
		counter+=1
		puts "#{symbol},#{counter}"
		 signal_file=File.expand_path("./#{symbol}.txt",$signal_path)
		 win_lost_statistic=File.expand_path("./#{folder}/#{symbol}.txt",$end_date_path)

		 if File.exists?(signal_file) && (not File.exists?(win_lost_statistic))
		   generate_counter_for_percent(symbol,folder,stragety)
	     end
	end
end


if $0==__FILE__
 start=Time.now
 strategy="hundun_1"
 init_strategy_name(strategy)
 #win_percent_folder="percent_5_num_5"
 # folder="percent_3_num_9_days"
 generate_all_win_lost(strategy)
 puts "cost=#{Time.now-start}"
end