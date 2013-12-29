require File.expand_path("../../../../init/small_fish_init.rb",__FILE__)
def remove_empty_day_from_history_and_copy_for_one(symbol)
    symbol_file_processed=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
    to_be_symbol_file=File.expand_path("./history_daily_data_2/#{symbol}.txt","#{AppSettings.resource_path}")

   # if (not File.exists?(symbol_file_processed)) && File.exists?(to_be_symbol_file)
      orig_content=File.read(to_be_symbol_file).split("\n")
      new_file=File.new(symbol_file_processed,"w+")

    #最新的在最后面，最老的在前面，方便添加数据
    orig_content.reverse.each do |line|
    result=line.split(",")
    result.shift(1)
      if result.size>2 #remove empty line
         new_file<<result.join("#") +"\n" unless line.match(",000,")
      end
    end
        
   new_file.close

#end
end


def remove_empty_day_from_history_and_copy

    count=0

    $all_stock_list.keys.each do |symbol|
        symbol_file_processed=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
        to_be_symbol_file=File.expand_path("./history_daily_data_2/#{symbol}.txt","#{AppSettings.resource_path}")

        #if (not File.exists?(symbol_file_processed)) && File.exists?(to_be_symbol_file)
    	remove_empty_day_from_history_and_copy_for_one(symbol)
        count+=1
    	puts "#{symbol_file_processed} done,count=#{count}"
   # end
  end


end


if $0==__FILE__
#首先要下载到history_daily_data_2,然后再处理到history_daily_data
#remove_empty_day_from_history_and_copy

remove_empty_day_from_history_and_copy_for_one("000009.sz")

end



