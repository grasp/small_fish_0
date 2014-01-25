require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/append_daily_data_to_history.rb",__FILE__)
require File.expand_path("../../1_data_collection/daily_data/save_daily_data_into_one_text.rb",__FILE__)

require File.expand_path("../../20_data_process/append_data.rb",__FILE__)
require File.expand_path("../../30_signal_gen/append_signal.rb",__FILE__)

	strategy="hundun_1"
	date="2014-01-23"

	init_strategy_name(strategy)

#puts appened_today_daily_data

	append_all_data_process(strategy)

    append_all_signal(strategy)