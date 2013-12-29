require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require "json"

def filter_daily_k_statistic(symbol,folder,win_percent,lost_percent,win_counter,lost_counter)
    source_file=File.expand_path("./daily_k_statistic/#{folder}/#{symbol}.txt","#{AppSettings.resource_path}")
    target_file=File.expand_path("./daily_k_win_lost/#{folder}/#{symbol}.txt","#{AppSettings.resource_path}")

    contents=File.read(source_file).split("\n")
    
    contents.each do |line|
    	result=line.split("#")
    	win_lost_array=JSON.parse(result[1])
    	puts line if win_lost_array[1]>win_counter && win_lost_array[3]>win_percent

    end
end


if $0==__FILE__
	folder="percent_1_num_1_days"
	filter_daily_k_statistic("000009.sz",folder,0.9,0.9,3,3)
end