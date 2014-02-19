require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
def delete_last_line_for_history_data(symbol,date)

  symbol_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
  last_line=String.new
 if File.exists?(symbol_file)
  a=File.read(symbol_file).split("\n")
   last_line=a.last.to_s
   # puts "last line=#{a.last}" if symbol=="300317.sz"
   #print a.to_s if symbol=="300317.sz"
   raise if last_line.nil?

   if last_line.match(date) #最后一行有想删除的数据
    a.delete(last_line)

    file=File.new(symbol_file,"w+")

    a.each do |line|
    	file<<line+"\n"
    end

   file.close
  end
  end
end




if $0==__FILE__
	count=0
	$all_stock_list.keys.each do |symbol|
	 count+=1
    # delete_last_line_for_history_data(symbol,"2013-11-22")
     delete_lines_greater_then_date(symbol,"2013-11-01")
     puts " #{symbol},#{count}"
    end	
end