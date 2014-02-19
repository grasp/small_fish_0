
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

module  StockRawDataProcess
   include StockUtility
#依次为开盘，最高，最低，收盘，成交量
def generate_one_stock_macd(price_array)

  # price_array=price_hash.to_a.reverse  #最新的在最后面，对吗
   macd_day_array=[]
   result_macd_hash=Hash.new

   price_array.each_index do |back_day|
     date=price_array[back_day][0]
     macd_array=generate_macd_on_backday(price_array,back_day)
     result_macd_hash[date]=macd_array #unless macd_array[0]== "NaN"
  end#end of one day index

 result_macd_hash

end

def generate_macd_on_backday(price_array,back_day)
   #price_array=price_hash.to_a
   macd_day_array=[]
   result_macd_hash=Hash.new

   [1,2,3,4,5,10,20,30,60,100,120,200].each do |i|
   #  macd_day_array<<AppSettings.send("macd_#{i}_day")
   macd_day_array<<i
   end 

  # price_array.each_index do |back_day|
   #清空当日的均线数组
   macd_array=[]
   #计算每一日的各个均值
   macd_day_array.each do |macd_day|
    sum=0
    #算术求和
    real_day_count=0
    (macd_day-1).downto(0).each do |j|
      #边界处理
      back_day+j>price_array.size-1 ? index=price_array.size-1 : index=back_day+j

        high=price_array[index][1][1].to_f
        low=price_array[index][1][2].to_f
        close=price_array[index][1][3].to_f
      
       sum+=close
       real_day_count+=1
        
    end  #end of macd_day sum  
    average=((sum.to_f)/real_day_count).round(2)
    raise if average==0.0
    macd_array<<average 
    end #end of one of macd day
   macd_array
end
end

if $0==__FILE__

    include StockRawDataProcess

    start=Time.now
    strategy="hundun_1"
    price_hash=get_price_hash_from_history(strategy,"000004.sz")
    price_array=price_hash.to_a.reverse
	generate_one_stock_macd(price_array)
  #generate_one_stock_macd(price_hash)
  #generate_macd_on_backday(price_hash,0)
	puts "cost #{Time.now-start} second"
end