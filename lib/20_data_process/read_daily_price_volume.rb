require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

#将日线数据转化成hash
#hash的key 为日期数据
#hash 的值为几个基本数据，依次为开盘，最高，最低，收盘，成交量
def get_price_hash_from_history(strategy,symbol)
  
	price_volume_hash=Hash.new
	stock_file_path=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.send(strategy).raw_data}")
  return {} unless File.exist?(stock_file_path)
  #puts stock_file_path
  raise unless File.exist?(stock_file_path)
  #快速载入到内存
  daily_k_array=File.read(stock_file_path).split("\n")

  #最新的日子在前面
  daily_k_array.reverse.each do |line|	
  next if line.nil?   
 	daily_data = line.split("#")
  next if daily_data[1].to_f==0.0
  next if daily_data[5].to_f==0.0
  next if daily_data.size<3

 	#成交量为0的我们忽略不计，已经在前面处理掉了
 	#如果数据没有基于price_hash产生，就会有问题，索引的下标会不一样！！！ 	
 	#next if (daily_data[2].nil? ||daily_data[6].to_f==0)
 	price_volume_hash[daily_data[0]]=[daily_data[1],daily_data[2],daily_data[3],daily_data[4],daily_data[5],daily_data[6]]
 end
    price_volume_hash
end

if $0==__FILE__
	#puts read_daily_k_file("000009.sz")
   strategy_name="hundun_1"
    init_strategy_name(strategy_name)
    start=Time.now
	puts get_price_hash_from_history(strategy,"000009.sz")
	puts "cost=#{Time.now-start}"
end
