require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require "./generate_daily_k_signal.rb"
require "./statistic_daily_k.rb"
require "./statistic_for_all.rb"
require "./buy_record.rb"
require "./calculate_win.rb"
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
  report_folder=File.expand_path("./report",daily_k_path)
  Dir.mkdir(report_folder) unless File.exists?(report_folder)

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

 #buy_record(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date,"2013-05-09")
 #daily_K_calcuate_win(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date,"2013-05-09")

end

def report_one_day_daily_k
	
end


def strategy_8
   daily_k_path=AppSettings.daily_k_one_day_folder
   profit_percent=2
   during_days=5
   win_percent=65
   win_count=100
   statistic_end_date="2013-12-31"
   init_daily_k_report(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)

  report_percent=File.expand_path("./report/percent_#{profit_percent}_num_#{during_days}days_win_#{win_percent}_count_#{win_count}.txt",daily_k_path)
  report_percent_file=File.new(report_percent,"a+")
  report_percent_file<<"start calculate on #{Time.now}\n"
  report_percent_file.close

3.upto(6).each do |j|
30.downto(1).each do |i|
  date = Date.new(2013, j, -i)
 # d -= (d.wday - 5) % 7
 # puts date
  unless (date.wday==6 || date.wday==0)
    puts date
    # scan_signal_on_date("percent_3_num_7_days",could_buy_array,date.to_s)
    buy_record(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date,date.to_s)
    daily_K_calcuate_win(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date,date.to_s)
  end
end
end
end

if $0==__FILE__

 strategy_8

end