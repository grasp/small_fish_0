require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

#只删除最后一行，可以用于回退每日数据更新问题
def delete_last_line_with_date(target_file,date)
  last_line=String.new

  if File.exists?(target_file)
    #puts target_file
   a=File.read(target_file).split("\n")
   last_line=a.last.to_s
   raise if last_line.nil?
   if last_line.match(date) #最后一行有想删除的数据
     a.delete(last_line) 
     #puts "delete last line"
   end

   file=File.new(target_file,"w+")
   a.each do |line|
    file<<line+"\n"
   end
   file.close
  end
end


#处理单个 symbol的price文件
def delete_last_line_for_price(symbol,date)
    symbol_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
    delete_last_line_with_date(symbol_file,date) 
end

#处理单个 symbol的process文件
def delete_last_line_for_data_process(symbol,date)
    symbol_file=File.expand_path("./data_process/#{symbol}.txt","#{AppSettings.resource_path}")
    delete_last_line_with_date(symbol_file,date) 
end

#处理单个 symbol的signal文件
def delete_last_line_for_signal(symbol,date)
    symbol_file=File.expand_path("./signal/#{symbol}.txt","#{AppSettings.resource_path}")
    delete_last_line_with_date(symbol_file,date) 
end

#可以删除多行，可以用于恢复多个数据合并的时候数据混乱
def delete_lines_greater_then_date(target_file,date)
     if File.exists?(target_file)
       temp=File.read(target_file).split("\n")
       temp_file=File.new(target_file,"w+")

       temp.each do |line|
        old_date=line.split("#")[0]
        temp_file<<line+"\n" if old_date<=date
       end 
       temp_file.close
     end
end

#处理单个 symbol的price文件
def delete_lines_greater_then_date_for_price(symbol,date)
    symbol_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
    delete_lines_greater_then_date(symbol_file,date) 
end

#处理单个 symbol的process文件
def delete_lines_greater_then_date_for_process(symbol,date)
    symbol_file=File.expand_path("./data_process/#{symbol}.txt","#{AppSettings.resource_path}")
    delete_lines_greater_then_date(symbol_file,date) 
end

#处理单个 symbol的signal文件
def delete_lines_greater_then_date_for_signal(symbol,date)
    symbol_file=File.expand_path("./signal/#{symbol}.txt","#{AppSettings.resource_path}")
    delete_lines_greater_then_date(symbol_file,date) 
end

#处理全部的文件-price 
def delete_all_lines_greater_than_date_for_price(date)
   $all_stock_list.keys.each do |symbol|
     delete_lines_greater_then_date(symbol,date)
    end  
end