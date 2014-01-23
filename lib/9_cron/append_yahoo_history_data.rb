require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/history_data/append_history_data.rb",__FILE__)
require File.expand_path("../../20_data_process/append_data.rb",__FILE__)
require File.expand_path("../../30_signal_gen/append_signal.rb",__FILE__)

def append_all_price_file(strategy,date)
	#first get raw file
    append_all_history_data(date)
	
	#
end

if $0==__FILE__
	strategy="hundun_1"
	date="2014-01-17"
	symbol="000002.sz"
	init_strategy_name(strategy)
	#append_all_price_file(strategy,date)
	#append_all_data_process(strategy)

append_all_signal(strategy)
end