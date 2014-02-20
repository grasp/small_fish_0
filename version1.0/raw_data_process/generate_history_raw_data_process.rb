
require File.expand_path("../macd_history.rb",__FILE__)
require File.expand_path("../low_high_price_history.rb",__FILE__)
require File.expand_path("../volume_history.rb",__FILE__)
require File.expand_path("../raw_data/download_stock_history_daily.rb")

module  StockRawDataProcess
   include StockUtility
   include StockRawData
  #保存单只股票的初步数据加工
def generate_raw_data_process(strategy,symbol)

    #if not downloaded file, then download history at first
    raw_data_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data,"#{symbol}.txt")
    unless File.exists?(raw_data_file)
      download_yahoo_history(strategy,symbol)
    end

    #如果还没有原始数据，只好退出了
    return unless File.exists?(raw_data_file)

    #或许价格hash
    target_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data_process,"#{symbol}.txt")
   # puts "target_file_path=#{target_file_path}"
    price_hash=get_price_hash_from_history(strategy,symbol)
    
    #倒序存放，方便append
    reversed_price_array=price_hash.to_a.reverse
    price_array=price_hash.to_a
     
     # 不处理没有价格数据的文件
    return -1 if  price_hash.size==0

    result_macd_hash=generate_one_stock_macd(reversed_price_array)
    price_result=low_high_price_analysis(reversed_price_array)

   # price_hash=macd_result[1]
    low_price_hash=price_result[0]
    high_price_hash=price_result[1]

    volume_hash=volume_analysis(reversed_price_array)

    raw_data_process_file=File.new(target_file_path,"w+")

    price_array.each_index do |index|
        date=price_array[index][0]
        raw_data_process_file<<date
       # raw_data_process_file<<"#"+price_hash[date].to_s
        raw_data_process_file<<"#"+result_macd_hash[date].to_s
        raw_data_process_file<<"#"+low_price_hash[date].to_s
        raw_data_process_file<<"#"+high_price_hash[date].to_s
        raw_data_process_file<<"#"+volume_hash[date].to_s
        raw_data_process_file<<"\n"
    end
    raw_data_process_file.close
    return 0
end

#暂时不用
def batch_generate_raw_data_process(strategy)

    start=Time.now
    count=0

    $all_stock_list.keys.each do |symbol|      
      #假设文件夹的初始化已经做好了，这里不初始化了

      target_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data_process,"#{symbol}.txt")
      #如果已经存在历史文件，那就利用历史文件，跳过去
      next if  File.exists?(target_file_path)
      result=generate_raw_data_process(strategy,symbol) 
      count+=1
      puts "count=#{count},result=#{result},symbol=#{symbol}"    
    end
    puts "cost=#{Time.now - start}"
end

end



if $0==__FILE__
  #save_analysis_result("000009.sz")
  include StockRawDataProcess
  strategy="hundun_1"
  #generate_raw_data_process(strategy,"000004.sz")
  batch_generate_raw_data_process(strategy)
end