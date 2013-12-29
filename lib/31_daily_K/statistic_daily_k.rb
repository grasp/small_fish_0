require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def statistic_daily_k(symbol,folder)

    #folder="percent_3_num_3_days"
    daily_k_file=File.expand_path("./daily_k/#{symbol}.txt","#{AppSettings.resource_path}")
    win_lost_file=File.expand_path("./win_lost/#{folder}/#{symbol}.txt","#{AppSettings.resource_path}")

    win_lost_array=File.read(win_lost_file).split("\n")
    win_lost_hash=Hash.new
    daily_k_hash=Hash.new

    total_hash=Hash.new
    win_hash=Hash.new{0}
    lost_hash=Hash.new{0}

    win_lost_array.each do |line|
    	result=line.split("#")
    	win_lost_hash[result[0]]=result[1]
    end
    
   # print win_lost_hash
   daily_k_array=File.read(daily_k_file).split("\n")

   daily_k_array.each do |line|
    result=line.split("#")
    daily_k_hash[result[0]]=result[1]
   end


win_lost_hash.each do |date,w_l|
	key=""
	key=daily_k_hash[date]
	w_l=="true" ? win_hash[key]+=1 : lost_hash[key]+=1	
end

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

win_lost_statistic=File.expand_path("./daily_k_statistic/#{folder}/#{symbol}.txt","#{AppSettings.resource_path}")
s_file= File.new(win_lost_statistic,"w+")

  total_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|

  s_file<<key.to_s+"#"+value.to_s+"\n"
end
s_file.close

end

def statistic_for_all(folder)
   count=0
  $all_stock_list.keys.each do |symbol|

    daily_k_file=File.expand_path("./daily_k/#{symbol}.txt","#{AppSettings.resource_path}")
    win_lost_statistic=File.expand_path("./daily_k_statistic/#{folder}/#{symbol}.txt","#{AppSettings.resource_path}")
    #unless  File.exists?(win_lost_statistic)
     if File.exists?(daily_k_file)
       statistic_daily_k(symbol,folder)
       puts "#{symbol},#{count+=1}"
    end
  #end
  end
end

def one_symbol_statistic(symbol,daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)
  
      #folder="percent_3_num_3_days"
    daily_k_file=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/signal/#{symbol}.txt",daily_k_path)
    win_lost_file=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/win_lost_history/#{symbol}.txt",daily_k_path)

    win_lost_array=File.read(win_lost_file).split("\n")
    win_lost_hash=Hash.new
    daily_k_hash=Hash.new

    total_hash=Hash.new
    win_hash=Hash.new{0}
    lost_hash=Hash.new{0}

    win_lost_array.each do |line|
      result=line.split("#")
    
      win_lost_hash[result[0]]=result[1]
    end
    
   # print win_lost_hash
   daily_k_array=File.read(daily_k_file).split("\n")

   daily_k_array.each do |line|
    result=line.split("#")
     next if result[0]>statistic_end_date  #只统计到end date,为预测做打算
    daily_k_hash[result[0]]=result[1]
   end


win_lost_hash.each do |date,w_l|
  key=""
  key=daily_k_hash[date]
  w_l=="true" ? win_hash[key]+=1 : lost_hash[key]+=1  
end

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

win_lost_statistic=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/end_date_#{statistic_end_date}/one_statistic/#{symbol}.txt",daily_k_path)
s_file= File.new(win_lost_statistic,"w+")

  total_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|

  s_file<<key.to_s+"#"+value.to_s+"\n"
end
s_file.close
end

def all_symbol_statistic(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)
    count=0
    $all_stock_list.keys.each do |symbol|
    daily_k_file=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/signal/#{symbol}.txt",daily_k_path)
    win_lost_statistic=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/end_date_#{statistic_end_date}/one_statistic/#{symbol}.txt",daily_k_path)
    #puts win_lost_statistic
    if File.exists?(daily_k_file) && (not File.exists?(win_lost_statistic))
       one_symbol_statistic(symbol,daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)
       puts "daily k statisitc #{symbol},#{count+=1}"
    end
  end
end


if $0==__FILE__
 start=Time.now
 #generate_win_lost_counter()
 #generate_counter_for_percent("000009.sz")
 folder="percent_3_num_1_days"
 # folder="percent_3_num_9_days"
# statistic_daily_k("000009.sz",folder)
 statistic_for_all(folder)
 puts "cost=#{Time.now-start}"
end