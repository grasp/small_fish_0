#http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=sz002241&end_date=20130806&begin_date=20130101&type=plain
require 'net/http' 
require File.expand_path("../../../../init/small_fish_init.rb",__FILE__)

def download_history(symbol, start_date,end_date)

	url="http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{symbol}&end_date=#{end_date}&begin_date=#{start_date}&type=plain"
 	response= Net::HTTP.get("biz.finance.sina.com.cn","/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{symbol}&end_date=#{end_date}&begin_date=#{start_date}&type=plain" )
  response.split(",")
end

def download_all_history_on_day(date)
	target_file=File.expand_path("./daily_data/sina_history")

	$all_stock_list.keys.each do |yahoo_symbol|
   sina_id=yahoo_symbol.split(".").reverse.join  if yahoo_symbol.match("sz")
   sina_id=yahoo_symbol.gsub("ss","sh").split(".").reverse.join  if yahoo_symbol.match("ss")
   puts sina_id
	end
end



if $0==__FILE__
	result=`ipconfig`
    if result.match("10.69.70.47")
       ENV['http_proxy']="http://10.140.19.49:808"
       ENV['https_proxy']="https://10.140.19.49:808"
    end
	#puts download_history("sz000009", 20131112,20131112)
	download_all_history
end