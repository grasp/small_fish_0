require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def delete_lines_processed_data(symbol,start_date)
  	processed_data=File.expand_path("./data_process/#{symbol}.txt","#{AppSettings.resource_path}")
    
    if File.exists?(processed_data)
     contents=File.read(processed_data).split("\n")
     file=File.new(processed_data,"w+")
      contents.each do |line|
       	file<<line+"\n" unless line.split("#")[0]>=start_date
     end
     file.close
    end
end

def delete_all_lines_processed_data(start_date)
	count=0
	$all_stock_list.keys.each do |symbol|
		#processed_data=File.expand_path("./data_process/#{symbol}.txt","#{AppSettings.resource_path}")
		#if File.exists?(processed_data)
		  delete_lines_processed_data(symbol,start_date)
	   # end
	   count+=1
	   puts "#{symbol},#{count}"
	end
end


if $0==__FILE__
	#delete_lines_processed_data("000005.sz","2013-11-04")
	delete_all_lines_processed_data("2013-11-04")
end