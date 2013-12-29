
require File.expand_path("../macd_history.rb",__FILE__)
require File.expand_path("../low_high_price_history.rb",__FILE__)
require File.expand_path("../volume_history.rb",__FILE__)
require File.expand_path("../../22_data_validate/validate_history_data.rb",__FILE__)

def save_analysis_result(straty_name,symbol)

    result_file_path=File.expand_path("./#{symbol}.txt",$data_process_path)
    #analysis_result_file=File.new("#{symbol}.txt","w+")
    #puts result_file_path
    price_hash=get_price_hash_from_history(symbol)
    
    #倒序存放，方便append
    price_array=price_hash.to_a.reverse
     
     # 不处理没有价格数据的文件
    return -1 if  price_hash.size==0

    result_macd_hash=generate_one_stock_macd(price_hash)
    price_result=low_high_price_analysis(price_hash)

   # price_hash=macd_result[1]
    low_price_hash=price_result[0]
    high_price_hash=price_result[1]

    volume_hash=volume_analysis(price_hash)

    analysis_file=File.new(result_file_path,"w+")

   price_array.each_index do |index|
        date=price_array[index][0]
        analysis_file<<date
       # analysis_file<<"#"+price_hash[date].to_s
        analysis_file<<"#"+result_macd_hash[date].to_s
        analysis_file<<"#"+low_price_hash[date].to_s
        analysis_file<<"#"+high_price_hash[date].to_s
        analysis_file<<"#"+volume_hash[date].to_s
        analysis_file<<"\n"
    end
    analysis_file.close
    return 0
end

def save_all_analysis_result(straty_name)

    start=Time.now

    data_process_folder= File.expand_path("./data_process","#{AppSettings.resource_path}")   
    Dir.mkdir(data_process_folder) unless File.exists?(data_process_folder)

    count=0
  
    #无效数据留给前面去解决，后面的人只处理正确的数据
  #  invalide_list=get_invalid_history_daily_data_list

    $all_stock_list.keys.each do |stock_id|      
      target_file_path=File.expand_path("#{stock_id}.txt","#{AppSettings.send(straty_name).data_process_path}") 
      next if  File.exists?(target_file_path)
      next if not  File.exists?(File.expand_path("./history_daily_data/#{stock_id}.txt","#{AppSettings.send(straty_name).raw_data}"))
     # if (not File.exists?(target_file_path)) &&  (not invalide_list.include?(stock_id))  
        result=save_analysis_result(straty_name,stock_id) 
        count+=1
        puts "count=#{count},result=#{result}"
    #  end
    
    end
    puts "cost=#{Time.now - start}"
end





if $0==__FILE__
  #save_analysis_result("000009.sz")
  straty_name="hundun_1"
  init_strategy_name(straty_name)
  save_all_analysis_result(straty_name)
end