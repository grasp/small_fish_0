require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../generate_daily_k_signal.rb",__FILE__)
require "json"

def buy_chance(symbol,date,folder,win_percent,win_counter)
	source_file=File.expand_path("./daily_k_statistic/#{folder}/#{symbol}.txt","#{AppSettings.resource_path}")

	contents=File.read(source_file).split("\n")
	statistic_hash=Hash.new
	contents.each do |line|
		result=line.split("#")
		statistic_hash[result[0]]=result[1]
	end

	price_hash=get_price_hash_from_history(symbol)
# [win_percent,shang_ying_percent,xia_ying_percent,zheng_fu_percent_flag].to_s
	daily_k=generate_daily_k_signal_on_date(price_hash,date)
 unless statistic_hash[daily_k].nil? #如果历史数据存在
  statistic_array=JSON.parse(statistic_hash[daily_k])

  return true if statistic_array[3]>win_percent &&  statistic_array[1]>win_counter
end
  return false
end

def generate_buy_chance_on_date(date,folder,win_percent,win_counter)
	target_file=File.expand_path("./buy_record/daily_k/#{folder}/#{date}_percent_#{(win_percent*100).to_i}_count_#{win_counter}.txt","#{AppSettings.resource_path}")
	  count=0
	  temp_file=File.new(target_file,"a+")

	  $all_stock_list.keys.each do |symbol|
	  source_file=File.expand_path("./daily_k_statistic/#{folder}/#{symbol}.txt","#{AppSettings.resource_path}")
	  if File.exists?(source_file)
        temp_file<<symbol+"\n" if buy_chance(symbol,date,folder,win_percent,win_counter)
        puts "#{symbol},#{count+=1}"
	  end
 
    end
     temp_file.close
end

if $0==__FILE__
	symbol="000009.sz"
	date="2013-11-12"
	folder="percent_3_num_5_days"
	#puts buy_chance(symbol,date,folder,0.8,3)
	generate_buy_chance_on_date(date,folder,0.9,1)
end