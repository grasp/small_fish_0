
require File.expand_path("../read_daily_k.rb",__FILE__)
require File.expand_path("../../../init/config_load.rb",__FILE__)

#依次为开盘，最高，最低，收盘，成交量
def generate_one_stock_macd(raw_hash)

   #raw_hash=get_raw_data_from_file(symbol)
   raw_array=raw_hash.to_a

  # puts raw_array
   macd_day_array=[]
   result_macd_hash=Hash.new
   price_hash=Hash.new

   #从配置文件读取正真的均线天数，这样使得均线的天数可以调整
   [1,2,3,4,5,10,20,30,60,100,120].each do |i|
     macd_day_array<<AppSettings.send("macd_#{i}_day")
   end

   #puts  macd_day_array
   #index 0 is the newest
   #so let us start from the oldest date which index is raw_array_size -1

  # raw_array.each_index do |daily_k_index|
  
    last_macd_array=[] #保存上一次的MACD数组，用于计算均值，先清空

   0.upto(raw_array.size-1).each do |daily_k_index|
   
    #清空要保存的均值数组
    macd_array=[] #保存当天所有的MACD数组，并先清空
   	#不处理那些空数据
   	next if raw_array[daily_k_index].nil?

    #知道了日期
    date=raw_array[daily_k_index][0]

    #puts "handle  date =#{date}"

    #保存价格信息,将存储在数据处理结果中
    price_hash[date]=raw_array[daily_k_index][1]
  
   #开始计算每一日的各个均值
   macd_day_array.each_index do |index|

   macd_day=macd_day_array[index]
  # puts "macd_day=#{macd_day}"
   last_macd_day_price=last_macd_array[index]
  
  #先清空
   average_price=0

   #指数平均算法
 		xishu_today=(2.0/(macd_day+1)).to_f.round(5)
        xishu_last=((macd_day-1).to_f/(macd_day+1).to_f).to_f.round(5)

   		#puts  "raw_array#{new_index}=#{raw_array[new_index]}"
   		high=raw_array[daily_k_index][1][1].to_f
   		low=raw_array[daily_k_index][1][2].to_f
        close=raw_array[daily_k_index][1][3].to_f

        # 先计算当日价格
        #average_price=((high+low+2*close)/4).to_f.round(3)
        #average_price=close
        #puts "average_price=#{average_price},last_average_price=#{last_average_price}"

        last_macd_day_price=average_price if last_macd_day_price.nil?
        average_price=((xishu_today*(close-last_macd_day_price)+last_macd_day_price)).round(2)

    #puts "xishu_today=#{xishu_today},xishu_last=#{xishu_last},average_price=#{average_price},last_average_price=#{last_macd_day_price}"
   	macd_array<<average_price
   	end #end macd_day_array.each

   	last_macd_array=macd_array#保存这次的记录为下一次计算均值所用

  # print last_macd_array

   	result_macd_hash[date]=macd_array.to_s #unless macd_array[0]== "NaN"
end#end (raw_array.size-1).downto(0)

[result_macd_hash,price_hash]
end#generate_one_stock_macd(raw_hash)

if $0==__FILE__
	start=Time.now
    raw_hash=get_raw_data_from_file("000009.sz")
	generate_one_stock_macd(raw_hash)
	puts "cost #{Time.now-start} second"
end