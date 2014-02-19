require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def delete_last_line(symbol,date)
    
	raw_price_file=File.expand_path("./signal/#{symbol}.txt","#{AppSettings.resource_path}")
  if File.exists?(raw_price_file)
    a=File.read(raw_price_file).split("\n")
   last_line=a.last
   puts symbol
   if   (not last_line.nil?)  && last_line.match(date)
    a.delete_at(a.size-1)
    file=File.new(raw_price_file,"w+")
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
    # delete_last_line(symbol,"2013-11-08")
     delete_last_line(symbol,"2013-11-07")
     delete_last_line(symbol,"2013-11-06")
     delete_last_line(symbol,"2013-11-05")
     delete_last_line(symbol,"2013-11-04")
     puts " #{symbol},#{count}"
    end
end