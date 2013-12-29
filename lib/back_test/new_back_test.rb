
require File.expand_path("../../signal/read_data_process.rb",__FILE__)
require File.expand_path("../../signal/buy_signal.rb",__FILE__)
require File.expand_path("../../data_process/save_analysis_result.rb",__FILE__)


def back_test_one_stock(symbol,buy_policy_file,sell_policy_file,start_index,end_index)
    buy_policy_class=BuySettings.new(buy_policy_file)
    sell_policy_class=SellSettings.new(sell_policy_file)

    processed_data=read_data_process_file(symbol)
    price_hash=processed_data[0]
    full_price_array=price_hash.to_a
    full_macd_array=processed_data[1].to_a

    #买和卖作为一组信息，全部买卖数组
    all_buy_cell_pair=[]

    #买单操作序号
    buy_index=0
    #卖单操作序号
    sell_index=0
    buy_flag=false
    

    puts "start on date=#{full_price_array[end_index][0]},end on date=#{full_price_array[start_index][0]}" 

    #index is back_days in full price array, as we sort with date
    #单独一组买和卖
    buy_sell_pair=[]
    (end_index-1).downto(start_index).each do |index|   
      
      date=full_price_array[index][0]

      print "#{date} #{full_macd_array[index][1]}"+"\n"
     # puts  date
      price_array=full_price_array[index][1]
      buy_signal=generate_buy_signal(processed_data,index,buy_policy_class,date)
      #puts "buy_signal=#{buy_signal}"
        if buy_signal==true
          puts "buy on #{date} with price #{price_array[3]} with buy signal #{buy_signal}" 
          buy_sell_pair=[]
          buy_sell_pair<<date
          buy_sell_pair<<price_array[3]
          buy_index=index
          buy_flag=true
        end

      sell_signal=generate_sell_signal(processed_data,index,sell_policy_class,date)

        if sell_signal==true && buy_flag==true
          puts "sell on #{date} with price #{price_array[3]}"  
          buy_sell_pair<<date
          buy_sell_pair<<price_array[3]
          win_percent=(((price_array[3].to_f-buy_sell_pair[1].to_f)/buy_sell_pair[1].to_f)*100).round(2)
          buy_sell_pair<<win_percent.to_s+"%"
          buy_sell_pair<<(buy_index-index)
          sell_index+=1
          buy_sell_pair<<sell_index
          all_buy_cell_pair<<buy_sell_pair.reverse
          buy_flag=false
        end

    end

one_stock_win=0
 all_buy_cell_pair.each do |buy_sell_pair|
    one_stock_win+=buy_sell_pair[2].to_f
    print buy_sell_pair.to_s+"\n"

   # print processed_data[1][buy_sell_pair[6]].to_s+"#{buy_sell_pair[6]}_buy\n"
   # print processed_data[1][buy_sell_pair[4]].to_s+"#{buy_sell_pair[4]}_sell\n"

  end
puts "win percent=#{one_stock_win}%"
end



if $0==__FILE__

    start=Time.now
	buy_policy_file=File.expand_path("../../signal/buy_policy_1.yml",__FILE__)
	sell_policy_file=File.expand_path("../../signal/sell_policy_1.yml",__FILE__)
    symbol="000009.sz"
    save_analysis_result(symbol)
    back_test_one_stock(symbol,buy_policy_file,sell_policy_file,10,120)
    puts "cost time = #{Time.now-start} second"



end