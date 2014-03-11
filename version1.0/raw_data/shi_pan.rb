require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/get_last_date.rb",__FILE__)
require 'net/http' 
require 'ostruct' 

def download_history(strategy,symbol,start_date,end_date)

  sina_id=convert_yahoo_symbol_to_sina(symbol)
  startdate=start_date.gsub("-","").to_s
  enddate=end_date.gsub("-","").to_s

  #puts "start date=#{start_date},end_date=#{end_date},sina_id=#{sina_id}"
  #puts "new start date=#{startdate},end_date=#{startdate},sina_id=#{sina_id}"

  url="http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{sina_id}&end_date=#{enddate}&begin_date=#{startdate}&type=plain"
  response=""

 #puts url
  #begin
  response= Net::HTTP.get("biz.finance.sina.com.cn","/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{sina_id}&end_date=#{enddate}&begin_date=#{startdate}&type=plain" )
 #print response
 # rescue
 # sleep 600
 # response= Net::HTTP.get("biz.finance.sina.com.cn","/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{symbol}&end_date=#{end_date}&begin_date=#{start_date}&type=plain" )
 # end

  sina_array=response.split("\n")
  #1=>开盘
  #2=>最高
  #3=>收盘
  #4->最低
  #5= 成交量

  #开盘，最高，最低，收盘，成交量
  #print "#{sina_array}\n"

  sina_array
end

	def append_raw_data(strategy,symbol)

	 last_date=get_last_date_of_raw_date(strategy,symbol)

   today=Time.now.to_s[0..9]
   #puts "last date=#{last_date},today=#{today}"
   gap_date_array=get_gap_date_array(last_date,today)

   # 如果没有gap，那就不做处理
   if gap_date_array.size==0
    puts "#{symbol} already latest!"
     return 
   else
    puts "gap_date_array size =#{gap_date_array.size}"
   end

   start_date=gap_date_array.first[0]
   end_date=gap_date_array.last[0]

   sina_array=download_history(strategy,symbol,gap_date_array.first[0],gap_date_array.last[0])
   return_array=[]
   
   #新浪的量和yahoo的量相差100，新浪以手为单位
   sina_array.each do |daily_k|
     #print "#{daily_k} \n"
     new_array=[]
     result=daily_k.split(",")
     temp=result[4]
     result[4]=result[3]
     result[3]=temp

     # print "#{result}\n"
     new_array<<symbol
     new_array+=result     
     new_array[new_array.size-1]=new_array[new_array.size-1].to_i*100
     
     new_array<<result[4] #为了和yahoo保持一致
     #print "new_array=#{new_array}"
     return_array<<new_array
  end

#转化成文本行，并附加到文件中
 raw_data_path=File.join(Strategy.send(strategy).root_path,symbol,\
  Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data,"#{symbol}.txt")
 raw_data_file=File.new(raw_data_path,"a+")

 return_array.each do |daily_k|
    daili_k_line=daily_k.join(",")+"\n"
    raw_data_file<<daili_k_line
 end

 raw_data_file.close
 return_array
end


def batch_append_raw_data(strategy,symbol_array)
  count = 0
 symbol_array.each do |symbol|
   puts "symbol=#{symbol},count =#{count}"
   append_raw_data(strategy,symbol)
 end

end

if $0==__FILE__
	include StockUtility
	strategy_file=File.expand_path("../../utility/strategy.yml",__FILE__)
	strategy="hundun_1"
	symbol="000005.sz"
   #append_raw_data(strategy,symbol)
  start=Time.now
  symbol_array=$all_stock_list.keys[0..2470]
  batch_append_raw_data(strategy,symbol_array)
  puts "#{Time.now - start}"
end