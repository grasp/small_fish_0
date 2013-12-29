
require File.expand_path("../read_daily_price_volume.rb",__FILE__)

#依次为开盘，最高，最低，收盘，成交量
#TBD：有几天成交量为0，因为没有开市，需要特殊处理
def volume_analysis(price_hash)
   #raw_hash=get_raw_data_from_file(symbol)
   price_array=price_hash.to_a
   day_array=[] #存储  

   volume_hash=Hash.new 

   [1,2,3,4,5,10,20,30,60,100,120].each do |i|
     day_array<<AppSettings.send("volume_#{i}_day")
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

def generate_volume_array_on_backday(price_array,back_day)
    # price_array=price_hash.to_a
   day_array=[] #存储  


   [1,2,3,4,5,10,20,30,60,100,120].each do |i|
     day_array<<AppSettings.send("volume_#{i}_day")
   end

   volume_array=[]

   #计算每一日的各个均值
   day_array.each do |number_day|
    sum=0
    count=0
    number_day.downto(1).each do |j|
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


if $0==__FILE__
	start=Time.now
	price_hash=get_price_hash_from_history("000009.sz")
	#volume_analysis(price_hash)
  puts generate_volume_array_on_backday(price_hash,0)
	puts "cost #{Time.now-start} second"
end