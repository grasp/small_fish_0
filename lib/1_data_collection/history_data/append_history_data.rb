require File.expand_path("../../../../init/small_fish_init.rb",__FILE__)

def append_history_data(source_folder,symbol)

	source_file=File.expand_path("./#{source_folder}/#{symbol}.txt","#{AppSettings.resource_path}")
	target_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")

    raw_data_contents=File.read(source_file).split("\n")
    exsisted_data_contents=File.read(target_file)


    temp_file=File.new(target_file,"a+")
	last_line=temp_file.readlines[-2..-1].to_s

   last_date=last_line.match(/\d\d\d\d-\d\d-\d\d/).to_s
   #raise if raw_data_contents.to_s.match(last_date)
   
   raw_data_contents.reverse.each do |line|
		  a=line.match(/\d\d\d\d-\d\d-\d\d/).to_s
		   result=line.split(",")
    		result.shift(1)
    		#puts "result=#{result}"
    		temp_file<<result.join("#") +"\n" if (not exsisted_data_contents.match(a)) && result.size>3 #防止重复记录
	end
	temp_file.close
end

def append_all_history_data
   count=0

	$all_stock_list.keys.each do |symbol|
	  count+=1
	  puts "#{symbol},count=#{count}"

	  raw_data_path=File.expand_path("./history_daily_data_3/#{symbol}.txt","#{AppSettings.resource_path}")
	  exsisted_data=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
		
		if File.exists?(raw_data_path) && File.exists?(exsisted_data)
          append_history_data("history_daily_data_3",symbol)
        end
    end
end

def append_all_history_data_for_folder(date_folder)
    count=0
    $logger.info("start to append history data for #{date_folder}")
	$all_stock_list.keys.each do |symbol|
	  count+=1

	  
	  source_file=File.expand_path("./#{date_folder}/#{symbol}.txt","#{AppSettings.resource_path}")
	  target_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
	  #TBD append之前，需要确认是否能够append,或者只append需要的数据，或者是否需要删除

		if File.exists?(source_file) && File.exists?(target_file)
          append_history_data("#{date_folder}",symbol)
          puts "#{symbol},count=#{count}"
        end
    end
    $logger.info("append history data done on #{Time.now}")
end


if $0==__FILE__

#append_all_history_data
append_all_history_data_for_folder("2013-11-22")
#append_history_data("history_daily_data_3/2013-11-22","000009.sz")
end