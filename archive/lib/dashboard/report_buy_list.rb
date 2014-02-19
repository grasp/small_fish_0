require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../4_win_lost/generate_win_lost2.rb",__FILE__)


def report_win_percent(algorithim_name,date)

end

def init_raw_data
    raw_data_path=AppSettings.raw_data    
    Dir.mkdir(raw_data_path) unless File.exists?(raw_data_path)

    history_data_path=File.expand_path("./history_daily_data",raw_data_path)
    Dir.mkdir(history_data_path) unless File.exists?(history_data_path)

    history_data_path=File.expand_path("./history_daily_data2",raw_data_path)
    Dir.mkdir(history_data_path) unless File.exists?(history_data_path)

    history_data_path=File.expand_path("./history_daily_data3",raw_data_path)
    Dir.mkdir(history_data_path) unless File.exists?(history_data_path)
end


def init_data_process_and_signal(algorithim_path)

    data_process_folder=File.expand_path("./data_process",algorithim_path)
    Dir.mkdir(data_process_folder) unless File.exists?(data_process_folder)

    signal_folder=File.expand_path("./signal",algorithim_path)
    Dir.mkdir(signal_folder) unless File.exists?(signal_folder)
end

def init_buy_list(algorithim_path,date,statistic_end_date,profit_percent,duration,win_count,win_percent)

    init_raw_data

	Dir.mkdir(algorithim_path) unless File.exists?(algorithim_path)    
    profit_duration="percent_#{(profit_percent).to_i}_num_#{duration}_days"
    profit_duration_folder=File.expand_path("./#{profit_duration}",algorithim_path)

    init_data_process_and_signal(algorithim_path)

    puts "profit_duration_folder=#{profit_duration_folder}"
    Dir.mkdir(profit_duration_folder) unless File.exists?(profit_duration_folder)
    
    statistic_end_date_folder=File.expand_path("./end_date_#{statistic_end_date}","#{profit_duration_folder}")
    puts "statistic_end_date_folder=#{statistic_end_date_folder}"
    Dir.mkdir(statistic_end_date_folder) unless File.exists?(statistic_end_date_folder)


    statistic_folder=File.expand_path("./statistic",statistic_end_date_folder)
    Dir.mkdir(statistic_folder) unless File.exists?(statistic_folder)

   
	win_percent_count="percent_#{win_percent}_count_#{win_count}"
	win_percent_count_folder=File.expand_path("./#{win_percent_count}","#{statistic_end_date_folder}")
	puts "win_percent_count_folder=#{win_percent_count_folder}"
    Dir.mkdir(win_percent_count_folder) unless File.exists?(win_percent_count_folder)

    potential_buy_folder=File.expand_path("./potential_buy",win_percent_count_folder)
    Dir.mkdir(potential_buy_folder) unless File.exists?(potential_buy_folder)

    win_lost_folder=File.expand_path("./win_lost_history",profit_duration_folder)
    puts "win_lost_folder=#{win_lost_folder}"
    unless File.exists?(win_lost_folder)
      Dir.mkdir(win_lost_folder) 
      #generate win_lost by profit ,duration , and price
      genereate_all_symbol_win_lost(profit_percent,duration)
    end

    buy_record_folder=File.expand_path("./buy_record",win_percent_count_folder)
    Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)
    return buy_record_folder
end

def report_buy_list(algorithim_path,date,statistic_end_date,profit_percent,duration,win_count,win_percent)
    
    folder=init_buy_list(algorithim_path,date,statistic_end_date,profit_percent,duration,win_count,win_percent)
    source_folder=File.expand_path("./#{folder}/#{date}.txt",algorithim_path)
    puts File.exists?(source_folder)

end


def report_daily_k_buy_list

end

if $0==__FILE__

 algorithim_path=AppSettings.hun_dun
 date="2013-11-13"
 statistic_end_date="2013-09-30"
 profit_percent=3
 duration=7
 win_count=25
 win_percent=99

 report_buy_list(algorithim_path,date,statistic_end_date,profit_percent,duration,win_count,win_percent)
end