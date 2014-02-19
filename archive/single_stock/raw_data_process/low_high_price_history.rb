require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)

module StockRawDataProcess
  include StockUtility
#依次为开盘，最高，最低，收盘，成交量
def low_high_price_analysis(price_array)

  # price_array=price_hash.to_a.reverse #最新的数据在第一个

   day_array=[] #存储  

   low_price_hash=Hash.new
   high_price_hash=Hash.new

   price_array.each_index do |daily_k_index|
     date=price_array[daily_k_index][0]
   #  puts "date=#{date}"
     result=low_high_price_array_on_backdays(price_array,daily_k_index)
     low_price_hash[date]=result[0]
     high_price_hash[date]=result[1]
  
   end#end of one day index

[low_price_hash,high_price_hash]
#print [low_price_hash,high_price_hash]
end

def low_high_price_array_on_backdays(price_array,back_day)
  
   # price_array=price_hash.to_a
    low_price_array=[]
    high_price_array=[]
    day_array=[]

  [1,2,3,4,5,10,20,30,60,100,120].each do |i|
     day_array<<i
   end

   #计算每一日的各个均值
   day_array.each do |number_day|
    lowest_price=10000000
    highest_price=-1

    (number_day-1).downto(0).each do |j|
        #边界处理
        back_day+j>price_array.size-1 ? index=price_array.size-1 : index=back_day+j
        print "price_array[index]=#{price_array[index]},#{index}" if  price_array[index].nil?

        #比较
        lowest_price=price_array[index][1][3] if price_array[index][1][3].to_f < lowest_price.to_f
        highest_price= price_array[index][1][3]  if highest_price.to_f<price_array[index][1][3].to_f

    end  #end of macd_day sum  

    raise if lowest_price.nil?
    low_price_array<<lowest_price
    high_price_array<<highest_price
 
    end #end of one of macd day
   [low_price_array,high_price_array]
end



end
if $0==__FILE__
    include StockRawDataProcess
    start=Time.now
    strategy="hundun_1"
    price_hash=get_price_hash_from_history(strategy,"000004.sz")
    price_array=price_hash.to_a.reverse
    low_high_price_analysis(price_array)
    puts "cost #{Time.now-start} second"
end