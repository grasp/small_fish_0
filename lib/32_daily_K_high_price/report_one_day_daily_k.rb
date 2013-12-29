require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require "./generate_daily_k_signal.rb"
require "./statistic_daily_k.rb"
require "./statistic_for_all.rb"
require "./buy_record.rb"
require File.expand_path("../../4_win_lost/generate_win_lost2.rb",__FILE__)

=begin
 目录结构
 daily_k_one_day
  percent_3_num_7_days
    end_date_2013_12_31
      percent_95_count_10
        calculate_win
        buy_record
        potential_buy
      statistic
  win_lost_history
=end

def init_daily_k_report(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)

	#daily_k_one_day_folder=AppSettings.daily_k_one_day
	Dir.mkdir(daily_k_path) unless File.exists?(daily_k_path)
	profit_duration_folder=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days",daily_k_path)
	signal_folder=File.expand_path("./signal",profit_duration_folder)
	end_date_folder=File.expand_path("./end_date_#{statistic_end_date}",profit_duration_folder)
	win_percent_folder=File.expand_path("./percent_#{win_percent}_count_#{win_count}",end_date_folder)
	calculate_win_folder=File.expand_path("./calculate_win",win_percent_folder)
	buy_record_folder=File.expand_path("./buy_record",win_percent_folder)
	potential_buy_folder=File.expand_path("./potential_buy",win_percent_folder)
	one_statistic_folder=File.expand_path("./one_statistic",end_date_folder)
	all_statistic_folder=File.expand_path("./all_statistic",end_date_folder)
	win_lost_history=File.expand_path("./win_lost_history",profit_duration_folder)

   Dir.mkdir(profit_duration_folder) unless File.exists?(profit_duration_folder)
	
    
   Dir.mkdir(win_lost_history)  unless File.exists?(win_lost_history)
    
   #generate win lost history file for signal generation
   $all_stock_list.keys.each do |symbol|
    	if File.exists?(File.expand_path("./history_daily_data/#{symbol}.txt",AppSettings.raw_data))
    		win_lost_symbol_file=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/win_lost_history/#{symbol}.txt","#{AppSettings.daily_k_one_day_folder}")
    		unless File.exists?(win_lost_symbol_file)
              generate_win_lost(win_lost_history,symbol,profit_percent,during_days)
              puts "generate win lost history for #{symbol}"
    		end
    	end
    end

  Dir.mkdir(signal_folder) unless File.exists?(signal_folder)
  $all_stock_list.keys.each do |symbol|
  	if File.exists?(File.expand_path("./history_daily_data/#{symbol}.txt",AppSettings.raw_data))
  		unless File.exists?(File.expand_path("./#{symbol}.txt",signal_folder))
  			generate_daily_k_signal_on_target_folder(signal_folder,symbol)
            puts "daily k signal on #{symbol} done"
  		end
  	end
  end
  
  Dir.mkdir(end_date_folder) unless File.exists?(end_date_folder)  
  Dir.mkdir(one_statistic_folder) unless File.exists?(one_statistic_folder)
 
  all_symbol_statistic(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)
  Dir.mkdir(all_statistic_folder) unless File.exists?(all_statistic_folder)
  statistic_all_daily_k(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)


 Dir.mkdir(win_percent_folder) unless File.exists?(win_percent_folder)
 Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)

 buy_record(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date,"2013-05-13")

end

def report_one_day_daily_k
	
end

if $0==__FILE__

   daily_k_path=AppSettings.daily_k_one_day_folder
   profit_percent=3
   during_days=7
   win_percent=65
   win_count=100
   statistic_end_date="2013-12-31"
   init_daily_k_report(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)

end