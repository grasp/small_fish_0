require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def validate_processed_data(date)

	data_folder=File.expand_path("./data_process","#{AppSettings.resource_path}")
    invalid_history_file=File.expand_path("./data_validate/invalid_data_process.txt","#{AppSettings.resource_path}")

	invalid_file=File.new(invalid_history_file,"w+")
    count=0
	Dir.new(data_folder).each do |file|
		next if (file=="." || file=="..")

		file_path= 	File.expand_path("./data_process/#{file}","#{AppSettings.resource_path}")

		temp_file=File.new(file_path)
		#puts file.readlines[1]
		last_line=temp_file.readlines[-2..-1].to_s
		#puts last_line if file.to_s.match("000002.sz")
		 unless last_line.match(date)
		  # 删除文件
		  invalid_file<< file.to_s+"\n" 
          count+=1
         end
		temp_file.close


		#file=File.new(file_path)

		#puts file.seek(-50, IO::SEEK_END)
        #file.close
	end

	puts "total invalid processed data file = #{count}"
    invalid_file.close
end

def get_invalid_history_daily_data_list_and_delete
	file_path=File.expand_path("./data_validate/invalid_data_process.txt","#{AppSettings.resource_path}")
	contents=File.read(file_path).split("\n")
	contents.each do |file|
		file_path= 	File.expand_path("./data_process/#{file}","#{AppSettings.resource_path}")
		File.delete(file_path)
	end

    return contents
end

if $0==__FILE__    

	#validate_processed_data("2013-11-01")
	#get_invalid_history_daily_data_list_and_delete
end