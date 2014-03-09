require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/get_last_date.rb",__FILE__)
require File.expand_path("../../signal/generate_history_signal.rb",__FILE__)
require File.expand_path("../../utility/read_raw_data_process.rb",__FILE__)

include StockSignal

def append_signal(strategy,symbol)

		#get the gap of the raw_process_data
	last_raw_process_date=get_last_date_of_raw_process_date(strategy,symbol)
	last_signal_date=get_last_date_of_signal(strategy,symbol)

  if last_signal_date.nil? ==true && last_raw_process_date.nil? ==false
     generate_history_signal(strategy,symbol)
     last_signal_date=get_last_date_of_signal(strategy,symbol)
  end

  #puts "last_raw_process_date=#{last_raw_process_date},last_signal_date=#{last_signal_date}"
  return if last_raw_process_date == last_signal_date

  gap_date=get_gap_date_array(last_signal_date,last_raw_process_date)
  
  puts "gap_date size =#{gap_date.size}"
  date_array=[]

  gap_date.each do |buy_date|
   date_array<<buy_date[0] if buy_date[1]=="true"
  end
  return if date_array.size==0

   raw_data_process=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data_process,"#{symbol}.txt")
    unless File.exists?(raw_data_process)
       generate_raw_data_process(strategy,symbol) 
    end

     save_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_full_data_process_file(strategy,symbol)
    
     #获取完成的价格hash
      price_hash=get_price_hash_from_history(strategy,symbol)

      #puts price_hash.to_a[1]

      #倒序？？ 为什么？？？
      
    #full_price_array=price_hash.to_a.reverse
    full_price_array=price_hash.to_a.reverse  #改动的目的是想让最新数据在最后一行
    #print full_price_array[0..2]

    #puts " another line"

     full_macd_array=processed_data_array[0].to_a
     
     raise if full_macd_array.nil?
     full_low_price_array=processed_data_array[1].to_a
     full_high_price_array=processed_data_array[2].to_a
     full_volume_array=processed_data_array[3].to_a

     #print full_volume_array[0..2]
     total_size=full_macd_array.size

     full_price_array.each_index do |index|
     date=full_price_array[index][0]
      next if date_array.include?(date)==false
     # puts date
     macd_signal_hash=judge_full_macd_signal(full_macd_array,index,total_size) 
     low_price_signal_hash=low_price_signal(full_low_price_array,full_price_array,index)
     high_price_signal_hash=high_price_signal(full_high_price_array,full_price_array,index)
     volume_signal_hash=generate_volume_sigmal_by_full(strategy,price_hash.to_a,full_volume_array,index)        
     open_signal=generate_open_signal(strategy,full_price_array,index)

      unless volume_signal_hash.nil?
        save_hash[date]=macd_signal_hash.merge(low_price_signal_hash).merge(high_price_signal_hash).merge(volume_signal_hash).merge(open_signal)
       end
     end

 # signal_file_path=File.expand_path("./#{symbol}.txt",$signal_path)
   signal_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")

   signal_file=File.new(signal_file_path,"a+")

   save_hash.sort_by {|key,value| key}.each do |date,s_hash|  
     signal_file<<date+"#"
     signal_file<<s_hash.values.to_s+"\n"
   end

   signal_file.close
end

def batch_append_signal(strategy,symbol_array)
  count=0
   symbol_array.each do |symbol|
    puts "#{symbol},#{count}"
    append_signal(strategy,symbol)
    count+=1
   end
end

if $0==__FILE__
	start = Time.now
	strategy="hundun_1"
	symbol="000005.sz"
	#append_signal(strategy,symbol)
	symbol_array = $all_stock_list.keys[0..2470]
	puts "symbol_array.size=#{symbol_array.size}"
	batch_append_signal(strategy,symbol_array)
	puts "#{Time.now-start}"
end