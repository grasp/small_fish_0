require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
def validate_processed_data_no_nil
	count=0
	$all_stock_list.keys.each do |symbol|
		processed_data=File.expand_path("./data_process/#{symbol}.txt","#{AppSettings.resource_path}")
	count+=1
		if File.exists?(processed_data)
	      puts  symbol if File.read(processed_data).match("nil")
	    end
	end
puts count
end


if $0==__FILE__
	validate_processed_data_no_nil
end