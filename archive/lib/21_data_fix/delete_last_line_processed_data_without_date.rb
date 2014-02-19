
require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def delete_last_line_processed_data(symbol)
    
  symbol_file=File.expand_path("./data_process/#{symbol}.txt","#{AppSettings.resource_path}")
  if File.exists?(symbol_file)

   a=File.read(symbol_file).split("\n")
   last_line=a.last
   unless last_line.match(/\d\d\d\d-\d\d-\d\d/) #最后一行没有日期数据
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
     delete_last_line_processed_data(symbol)

     puts " #{symbol},#{count}"
    end
end