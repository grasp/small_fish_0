require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require 'json'

def generate_win_lost_counter()
	win_lost=File.expand_path("./win_lost","#{AppSettings.resource_path}")
	Dir.new(win_lost).each do |folder|
      puts folder
	end
end

#统计输赢的信号比例
def generate_counter_for_percent(algorithim_path,symbol,profit_percent,during_day,end_date)
    #folder="percent_3_num_3_days"
   # signal_file=File.expand_path("./signal/#{symbol}.txt","#{AppSettings.resource_path}")
    signal_file=File.expand_path("./signal/#{symbol}.txt","#{AppSettings.hun_dun}")
    folder="percent_#{profit_percent}_num_#{during_day}_days"
    win_lost_file=File.expand_path("./#{folder}/win_lost_history/#{symbol}.txt",algorithim_path)

    win_lost_array=File.read(win_lost_file).split("\n")
    win_lost_hash=Hash.new
    signal_hash=Hash.new

    win_lost_array.each do |line|
      #如果日期大于end_date,我们将不会放进去,这样就可以只统计end_date之前的数据，方便后退测试了
    	result=line.split("#")
    	win_lost_hash[result[0]]=result[1] if result[0]<end_date
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
      #如果日期大于 end_date,我们也不会放到统计里面
     signal_hash[result[0]]=temp if result[0]<end_date
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

win_lost_statistic=File.expand_path("./#{folder}/end_date_#{end_date}/statistic/#{symbol}.txt",algorithim_path)

s_file= File.new(win_lost_statistic,"w+")

  total_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|

  s_file<<key.to_s+"#"+value.to_s+"\n"
end
s_file.close

end


def generate_all_statistic_before_end_date(algorithim_path,profit_percent,during_day,end_date)
    #folder="percent_1_num_1_days"

    folder="percent_#{profit_percent}_num_#{during_day}_days"
    counter=0
	 $all_stock_list.keys.each do |symbol|
		  counter+=1
	  	puts "start #{symbol},#{counter}"
		  signal_file=File.expand_path("./signal/#{symbol}.txt",algorithim_path)
		  win_lost_statistic=File.expand_path("./#{folder}/end_date_#{end_date}/statistic/#{symbol}.txt",algorithim_path)
		  if File.exists?(signal_file) && (not File.exists?(win_lost_statistic))
		     #generate_counter_for_percent(symbol,folder)
         generate_counter_for_percent(algorithim_path,symbol,profit_percent,during_day,end_date)
	    end
	end
end


if $0==__FILE__
 start=Time.now
 algorithim_path=AppSettings.hun_dun
 date="2013-11-13"
 #statistic_end_date="2012-12-31"
 statistic_end_date="2013-09-30"
 profit_percent=3
 during_day=7
 #win_count=10
 #win_percent=95

 #folder="percent_3_num_7_days"
# folder="percent_3_num_9_days"
 generate_all_statistic_before_end_date(algorithim_path,profit_percent,during_day,statistic_end_date)
 puts "cost=#{Time.now-start}"
end