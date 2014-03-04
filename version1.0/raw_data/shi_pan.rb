require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/get_last_date.rb",__FILE__)
require 'net/http' 
require 'ostruct' 

def download_history(strategy,symbol,start_date,end_date)

  sina_id=convert_yahoo_symbol_to_sina(symbol)
  startdate=start_date.gsub("-","").to_s
  enddate=end_date.gsub("-","").to_s

  url="http://biz.finance.sina.com.cn/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{sina_id}&end_date=#{enddate}&begin_date=#{startdate}&type=plain"
  response=""
  #begin
  response= Net::HTTP.get("biz.finance.sina.com.cn","/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{sina_id}&end_date=#{enddate}&begin_date=#{startdate}&type=plain" )
 print response
 # rescue
 # sleep 600
 # response= Net::HTTP.get("biz.finance.sina.com.cn","/stock/flash_hq/kline_data.php?&rand=random(10000)&symbol=#{symbol}&end_date=#{end_date}&begin_date=#{start_date}&type=plain" )
 # end

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

	def append_raw_data(strategy,symbol)

	 last_date=get_last_date_of_raw_date(strategy,symbol)

   today=Time.now.to_s[0..9]
   puts "last date=#{last_date},today=#{today}"
   gap_date_array=get_gap_date_array(last_date,today)

   print download_history(strategy,symbol,gap_date_array.first[0],gap_date_array.last[0])



	end


if $0==__FILE__
	include StockUtility
	strategy_file=File.expand_path("../../utility/strategy.yml",__FILE__)
	strategy="hundun_1"
	symbol="000004.sz"

 print  append_raw_data(strategy,symbol)
end