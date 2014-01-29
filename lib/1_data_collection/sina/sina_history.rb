#http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=sz002241&end_date=20130806&begin_date=20130101&type=plain
require 'net/http' 
require File.expand_path("../../../../init/small_fish_init.rb",__FILE__)

def download_history(symbol, start_date,end_date)


	url="http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{symbol}&end_date=#{end_date}&begin_date=#{start_date}&type=plain"
  response=""
  begin
 	response= Net::HTTP.get("biz.finance.sina.com.cn","/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{symbol}&end_date=#{end_date}&begin_date=#{start_date}&type=plain" )
  rescue
  sleep 600
  response= Net::HTTP.get("biz.finance.sina.com.cn","/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{symbol}&end_date=#{end_date}&begin_date=#{start_date}&type=plain" )
  end

  sina_array=response.split(",")
  #1=>开盘
  #2=>最高
  #3=>收盘
  #4->最低
  #5= 成交量

  #开盘，最高，最低，收盘，成交量
  print sina_array
  puts " "
  sina_array
end

def download_all_history_on_day(date)

  new_date=date.gsub("-","")
	target_file_path=File.expand_path("daily_data/sina_history/#{date}.txt",$raw_data)
  target_file =File.new(target_file_path,"a+")
  count=0
  
	$all_stock_list.keys.each do |yahoo_symbol|
   count+=1
   sina_id=yahoo_symbol.split(".").reverse.join  if yahoo_symbol.match("sz")
   sina_id=yahoo_symbol.gsub("ss","sh").split(".").reverse.join  if yahoo_symbol.match("ss")
   puts "sina id=#{sina_id},yahoo_symbol=#{yahoo_symbol},count=#{count}"

	 sina_array=download_history(sina_id,new_date,new_date)
   new_array=Array.new
   new_array[0]=sina_id
   new_array[1]=sina_array[0]
   new_array[2]=sina_array[1]
   new_array[3]=sina_array[3]
   new_array[4]=sina_array[2]
   new_array[5]=sina_array[4]
   new_array[6]=sina_array[3]
   
   # break if count>2
   target_file<<new_array.join("#")+"\n"

   sleep 5

  end

  target_file.close
end



if $0==__FILE__
	result=`ipconfig`
    if result.match("10.69.70.47")
       ENV['http_proxy']="http://10.140.19.49:808"
       ENV['https_proxy']="https://10.140.19.49:808"
    end
	#puts download_history("sz000009", 20131112,20131112)
  #download_all_history
  strategy="hundun_1"
 init_strategy_name(strategy)
  download_all_history_on_day("2014-01-27")
# download_history("sz000009", 20140127,20140127)

end