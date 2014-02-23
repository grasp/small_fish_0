
require File.expand_path("../macd_signal.rb",__FILE__)
require File.expand_path("../low_price_signal.rb",__FILE__)
require File.expand_path("../high_price_signal.rb",__FILE__)
require File.expand_path("../open_signal.rb",__FILE__)
require File.expand_path("../volume_signal.rb",__FILE__)
require File.expand_path("../raw_data_process/generate_history_raw_data_process.rb")

module StockSignal
    include StockUtility
    include StockRawDataProcess
    
def generate_history_signal(strategy,symbol)

    #假如Raw_data_process还没有生成，那就我们帮忙生成一次
    raw_data_process=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data_process,"#{symbol}.txt")
    unless File.exists?(raw_data_process)
       generate_raw_data_process(strategy,symbol) 
    end

    #如果此时还没有初步加工数据，只好退出了
    return unless File.exists?(raw_data_process)

     #各种信号放到一起用于保存的Hash
	  save_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_full_data_process_file(strategy,symbol)
    
     #获取完成的价格hash
      price_hash=get_price_hash_from_history(strategy,symbol)

      #puts price_hash.to_a[1]

      #倒序？？ 为什么？？？
      
      full_price_array=price_hash.to_a.reverse

    
     full_macd_array=processed_data_array[0].to_a
      raise if full_macd_array.nil?
     full_low_price_array=processed_data_array[1].to_a
     full_high_price_array=processed_data_array[2].to_a
     full_volume_array=processed_data_array[3].to_a

     #最新的日期在前面，index 为0， back_day的数据为0+back_day
     total_size=full_macd_array.size

     full_price_array.each_index do |index|
       	date=full_price_array[index][0]

        macd_signal_hash=judge_full_macd_signal(full_macd_array,index,total_size) 
        low_price_signal_hash=low_price_signal(full_low_price_array,full_price_array,index)
        high_price_signal_hash=high_price_signal(full_high_price_array,full_price_array,index)
        volume_signal_hash=generate_volume_sigmal_by_full(strategy,price_hash.to_a,full_volume_array,index)        
        open_signal=generate_open_signal(strategy,full_price_array,index)

        save_hash[date]=macd_signal_hash.merge(low_price_signal_hash).merge(high_price_signal_hash).merge(volume_signal_hash).merge(open_signal)
     end

 # signal_file_path=File.expand_path("./#{symbol}.txt",$signal_path)
  signal_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")

   first_line_flag=true
   signal_file=File.new(signal_file_path,"w+")

   save_hash.each do |date,s_hash|
     signal_file<< s_hash.keys.to_s+"\n"   if first_line_flag==true
     signal_file<<date+"#"
     signal_file<<s_hash.values.to_s+"\n"
     first_line_flag=false  
   end
   signal_file.close
end


def batch_generate_history_signal(strategy)
   count=0

    $all_stock_list.keys.each do |symbol|
      #假设文件夹的初始化已经完成

      target_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
      next if File.exists?(target_file_path) && File.stat(target_file_path).size>0

      #源文件存在，并且目标文件不存在
         count+=1
         generate_history_signal(strategy,symbol)
         puts "count=#{count},symbol=#{symbol}"
       end
end
end
if $0==__FILE__
  include StockSignal
   # test_save_all_signal
  # generate_history_signal("hundun_1","000004.sz")
  strategy="hundun_1"
  batch_generate_history_signal(strategy)
 end

