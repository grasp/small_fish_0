require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../utility/get_last_date.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../utility/generate_win_lost.rb",__FILE__)

include StockUtility
def append_win_lost(strategy, symbol)

	#get the gap of the raw_process_data
	last_raw_date=get_last_date_of_raw_date(strategy,symbol)
	last_win_lost_date=get_last_date_of_win_lost(strategy,symbol)

  if last_win_lost_date.nil? ==true && last_raw_date.nil? ==false
     generate_win_lost(stragey,symbol)
     last_win_lost_date=get_last_date_of_win_lost(strategy,symbol)
  end

  #puts "last_raw_process_date=#{last_raw_process_date},last_signal_date=#{last_signal_date}"
  return if last_raw_date == last_win_lost_date

  gap_date=get_gap_date_array(last_win_lost_date,last_raw_date)
  win_expect_array=Strategy.send(strategy).win_expect.split("_")
  expected_gap_day=win_expect_array[3]
  percent=win_expect_array[1]
  #puts "percent =#{percent},gap_date size=#{gap_date.size}"
  return if gap_date.size==expected_gap_day #周末呢

  new_gap_array=[]
  gap_date.each do |item|
  	new_gap_array<<item[0] if item[1]=="true"
  end
#还有两天， 也出不来结果
return if new_gap_array.size == expected_gap_day

(expected_gap_day.to_i - 1).downto(0).each do |i|
	new_gap_array.delete_at(-(i+1))
end

price_hash=get_price_hash_from_history(strategy,symbol)
price_array=price_hash.to_a.reverse

save_hash=Hash.new

price_array.each_index do |index|
 
 if new_gap_array.include?(price_array[index][0])
   true_false=false
   today_price=price_array[index][1][3]
   1.upto(expected_gap_day.to_i).each do |i| 
    #puts "price_array[back_day-i][1][3].to_f=#{price_array[back_day-i]}"
    #注意是除以1000，因为我们的比例已经放大了10倍
    true_false||=(((price_array[index-i][1][3].to_f-today_price.to_f)/today_price.to_f)>=(percent.to_f/1000))

      # puts "#{price_array[index][0]}, today_price=#{today_price}, feature date = #{price_array[index-i][0]},feature price=#{price_array[index-i][1][3].to_f}\n" 
  end

    save_hash[price_array[index][0]]=true_false
 end
end
    if save_hash.size > 0
      win_lost_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
      win_lost_file=File.new(win_lost_path,"a+")
      save_hash.sort_by {|key,value| key}.each do |key,value|
      	#print "#{key},#{value} \n"
      	win_lost_file<<key+"#"+"#{value}"+"\n"
      end
      win_lost_file.close
    end
end

def batch_append_win_lost(strategy,symbol_array)
   count=0
   symbol_array.each do |symbol|
    puts "#{symbol},#{count}"
    append_win_lost(strategy,symbol)
    count+=1
   end
end

if $0==__FILE__

	start = Time.now
	strategy = "hundun_1"
	symbol="000005.sz"
	#append_win_lost(strategy, symbol)

	symbol_array = $all_stock_list.keys[0..2470]

	puts "symbol_array.size=#{symbol_array.size}"
	batch_append_win_lost(strategy,symbol_array)

	puts "cost #{Time.now - start}"
end