def read_processed_signal(symbol,will_key,win_percent,count)

  processed_signal_file=File.expand_path("./signal_process/two/#{will_key}/#{symbol}.txt","#{AppSettings.resource_path}")
  content=File.read(processed_signal_file)
  string_array=content.split("\n")
  result_array=[]
  string_array.each do |line|
  	result=line.split("#")
  	percent=result[6].split(",")
  	result_array<< result if (percent[1].to_i >count && percent[3].to_i >win_percent)
  end
  result_array
end

if $0==__FILE__
    will_key="up_p10_after_3_day"
	read_processed_signal("000004.sz",will_key)
end