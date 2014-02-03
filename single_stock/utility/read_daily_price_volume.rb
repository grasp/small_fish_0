require File.expand_path("../../utility/utility.rb",__FILE__)

#将日线数据转化成hash
#hash的key 为日期数据
#hash 的值为几个基本数据，依次为开盘，最高，最低，收盘，成交量
module StockUtility
  
def get_price_hash_from_history(strategy,symbol)
  
	price_volume_hash=Hash.new

  history_target_folder=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data)
  stock_file_path=File.expand_path("#{symbol}.txt",history_target_folder)

  # puts stock_file_path
  return {} unless File.exist?(stock_file_path)  #不做任何处理

  #快速载入到内存
  daily_k_array=File.read(stock_file_path).split("\n")

  #最新的日子在前面
  daily_k_array.each do |line|	
   
  next if line.nil?   
 	daily_data = line.split(",")
 #print daily_data.to_s+"\n"
  next if daily_data.size<3
 	price_volume_hash[daily_data[1]]=[daily_data[2],daily_data[3],daily_data[4],daily_data[5],daily_data[6],daily_data[7]]

 end
# puts price_volume_hash
    price_volume_hash
end
end

if $0==__FILE__
   strategy="hundun_1"
   symbol="000004.sz"
   start=Time.now
   get_price_hash_from_history(strategy,symbol)
	 puts "cost=#{Time.now-start}"
end
