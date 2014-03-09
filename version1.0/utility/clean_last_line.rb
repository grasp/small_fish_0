require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_list_init.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)
def delete_last_line_with_date(target_file,number)
  last_line=String.new

  if File.exists?(target_file)
    #puts target_file
   a=File.read(target_file).split("\n")
     # puts "old line =#{a.size}"
   number.downto(1).each do |i|
   	a.delete_at(-i)
   end
   #puts "new line =#{a.size}"

   file=File.new(target_file,"w+")
   a.each do |line|
    file<<line+"\n"
   end

   file.close
  end

end


def delete_raw_data_file(strategy)   
    count = 0
    $all_stock_list.keys.each do |symbol|
      count +=1
      puts "#{count},#{symbol}"
      target_file=File.join(Strategy.send(strategy).root_path,symbol,\
      Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data,"#{symbol}.txt")
      delete_last_line_with_date(target_file,6)    
    end
end

def delete_raw_process_data_file(strategy)   
    count = 0
    $all_stock_list.keys.each do |symbol|
      count +=1
      puts "#{count},#{symbol}"
      target_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data_process,"#{symbol}.txt")
      delete_last_line_with_date(target_file,6)    
    end
end

def delete_signal_file(strategy)   
    count = 0
    $all_stock_list.keys.each do |symbol|
      count +=1
      puts "#{count},#{symbol}"
      target_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
      delete_last_line_with_date(target_file,6)    
    end
end

if $0==__FILE__
	start=Time.now
    delete_signal_file("hundun_1")
    puts "cost time =#{Time.now - start}"

end