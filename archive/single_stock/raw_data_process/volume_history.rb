
require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

module  StockRawDataProcess
   include StockUtility

#依次为开盘，最高，最低，收盘，成交量
#TBD：有几天成交量为0，因为没有开市，需要特殊处理
def volume_analysis(price_array)
   #raw_hash=get_raw_data_from_file(symbol)
   #price_array=price_hash.to_a
   day_array=[] #存储  

   volume_hash=Hash.new 

   [1,2,3,4,5,10,20,30,60,100,120].each do |i|
     day_array<<i
   end

   price_array.each_index do |back_day|

   volume_array=[]

   #计算每一日的各个均值
   day_array.each do |number_day|
   	sum=0
   	count=0
   	(number_day-1).downto(0).each do |j|
        #边界处理
        back_day+j>price_array.size-1 ? index=price_array.size-1 : index=back_day+j
        sum+=price_array[index][1][4].to_f
        count+=1
   	end  #end of macd_day sum  
    average_volume=(sum.to_f/count.to_f).round(2)
    volume_array << average_volume
 
   	end #end of one of macd day
   	volume_hash[price_array[back_day][0]]=volume_array

end#end of one day index

volume_hash

end
#这个函数没有什么用，因为volume已经是直接的结果了
def generate_volume_array_on_backday(price_array,back_day)
    # price_array=price_hash.to_a
   day_array=[] #存储  


   [1,2,3,4,5,10,20,30,60,100,120].each do |i|
     day_array<<i
   end

   volume_array=[]

   #计算每一日的各个均值
   day_array.each do |number_day|
    sum=0
    count=0
    (number_day-1).downto(0).each do |j|#修复一个边界问题
        #边界处理
        back_day+j>price_array.size-1 ? index=price_array.size-1 : index=back_day+j
        sum+=price_array[index][1][4].to_f
        count+=1 
    end  #end of macd_day sum  
    average_volume=(sum.to_f/count.to_f).round(2)
    volume_array << average_volume
 
    end #end of one of macd day 
 volume_array
end
end

if $0==__FILE__
  include StockRawDataProcess
	start=Time.now
  strategy="hundun_1"
  price_hash=get_price_hash_from_history(strategy,"000004.sz")
  volume_analysis(price_hash.to_a.reverse)
	puts "cost #{Time.now-start} second"
end