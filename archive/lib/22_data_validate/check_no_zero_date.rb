require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def check_no_zero_date(symbol)

	target_file=File.expand_path("./data_validate/check_no_zero_date.txt","#{AppSettings.resource_path}")
	temp_file=File.new(target_file,"a+")
	source_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
	contents=File.read(source_file)
	temp_file<< symbol+"\n" if contents.match(/#0\.0/)
    temp_file.close
end

def check_all_no_zero_date
	target_file=File.expand_path("./data_validate/check_no_zero_date.txt","#{AppSettings.resource_path}")
	temp_file=File.new(target_file,"w+")
	 temp_file.close

	$all_stock_list.keys.each do |symbol|
		source_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
		if File.exists?(source_file)
		   check_no_zero_date(symbol)
	    end
	end
end

if $0==__FILE__

	#check_no_zero_date("000009.sz")
	check_all_no_zero_date
end