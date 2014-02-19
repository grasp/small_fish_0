require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)


def single_signal_statistic(end_date,sell_strategy)
  Dir.mkdir(AppSettings.single_signal_statistic) unless File.exists?(AppSettings.single_signal_statistic)
  end_date_folder=File.expand_path("./#{end_date}",AppSettings.single_signal_statistic)
  raise unless File.exists?(AppSettings.single_signal)

  Dir.mkdir(end_date_folder) unless File.exists?(end_date_folder)
   win_lost_folder=AppSettings.win_lost
#创建signal folder
  Dir.new(AppSettings.single_signal).each do |signal_folder| #对每一个signal，统计各种盈利百分比可能
  	unless (signal_folder =="." ||signal_folder =="..")
  		puts "start statistic signal=#{signal_folder}"
  signal_source_folder=File.expand_path(signal_folder,AppSettings.single_signal)
  	statistic_folder=File.expand_path("./#{signal_folder}",end_date_folder)
  #	puts sub_folder

  	Dir.mkdir(statistic_folder) unless File.exists?(statistic_folder)

    #根据输赢统计信号
  	Dir.new(win_lost_folder).each do |percent_num_day_folder|
  		unless (percent_num_day_folder =="." ||percent_num_day_folder =="..")
  			puts percent_num_day_folder

  			statistic_percent_num_day_folder=File.expand_path(percent_num_day_folder,statistic_folder)
  			Dir.mkdir(statistic_percent_num_day_folder)  unless File.exists?(statistic_percent_num_day_folder)

  			win_lost_sell_strategy_folder=File.expand_path("./#{percent_num_day_folder}/#{sell_strategy}",win_lost_folder)

  			statistic_sell_strategy_folder=File.expand_path("./#{sell_strategy}",statistic_percent_num_day_folder)
  			Dir.mkdir(statistic_sell_strategy_folder) unless File.exists?(statistic_sell_strategy_folder)

           Dir.new(signal_source_folder).each do |symbol|
           	unless (symbol =="." ||symbol =="..")
  			  signal_source_file=File.expand_path("./#{symbol}",signal_source_folder)
  			  win_lost_signal_file=File.expand_path("./#{symbol}",win_lost_sell_strategy_folder)
  			  target_statistic_file=File.expand_path("./#{symbol}",statistic_sell_strategy_folder)
  			  statistic_by_file(signal_source_file,win_lost_signal_file,target_statistic_file)
  		    end
  		  end
  		end
  	end
  end
end
end


 def statistic_by_file(signal_source,win_lost_file,target_statitic_file)
 signal_hash=Hash.new
 signal_content=File.read(signal_source).split("\n")

 signal_content.each do |line|
 	result=line.split("#")
 	signal_hash[result[0]]=result[1]
 end

 win_lost_hash=Hash.new
 win_lost_content=File.read(win_lost_file).split("\n")
 
 win_lost_content.each do |line|
 	result=line.split("#")
 	win_lost_hash[result[0]]=result[1]
 end

statistic_hash=Hash.new{0}

signal_hash.each do |date,result|
	win_lost=win_lost_hash[date]
	statistic_hash[win_lost]+=1 unless win_lost.nil?
end

statistic_file=File.new(target_statitic_file,"w+")
total=statistic_hash["true"]+statistic_hash["false"]

win_percent=(((statistic_hash["true"].to_f)/total)).round(2)

statistic_result=[total,statistic_hash["true"],statistic_hash["false"],win_percent]
statistic_file<<statistic_result.to_s
statistic_file.close
#puts statistic_result
 end


#为每一个 sell_strategy 生成统计

#end

if $0==__FILE__
    #signal_source_file="e:\\single_signal\\close_equal_high\\000009.sz.txt"
 	#win_lost_signal_file="e:\\win_lost\\percent_1_num_7_days\\buy_by_close_sell_by_close\\000009.sz.txt"
  	#target_statistic_file="e:\\single_signal_statistic\\2013-12-31\\close_equal_high\\percent_1_num_7_days\\buy_by_close_sell_by_close\\000009.sz.txt"

	single_signal_statistic("2013-12-31","buy_by_close_sell_by_close")
	#statistic_by_file(signal_source_file,win_lost_signal_file,target_statistic_file)


end