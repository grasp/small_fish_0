
require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)

#判断number day内将会涨跌
def generate_win_lost_on_backday(price_array,back_day,percent, number_day)

    #最后几天统计不能算，因为此时我们还不能知道是否盈利或者亏损，只能计算到倒数几天，因此原来的计算有误，需要重新计算
	raise if back_day<number_day.to_i

    true_false=false
    
    future_price_array=[]

    1.upto(number_day).each do |i|
    	number_day <<price_array[back_day-i][1][3].to_f
    end


    #index 0  是最新
    today_price_array=price_array[back_day]
    today_price=today_price_array[1][3]
#print  "today_price=#{today_price}, number_day=#{number_day} "
1.upto(number_day.to_i).each do |i|
  
 true_false||=(((price_array[back_day-i][1][3].to_f-today_price.to_f)/today_price.to_f)>=(percent.to_f/100))
 # puts "today_price=#{today_price},#{i} price=#{price_array[back_day-i][1][3].to_f} ,#{true_false}"
end
#print "\n"
return true_false

end


 
def generate_win_lost(stragey,target_folder,symbol,percent,number_day)

	price_hash=get_price_hash_from_history(stragey,symbol)
	price_array=price_hash.to_a
	size=price_hash.size



    file_path=File.expand_path("./#{target_folder}/#{symbol}.txt",$win_lost_path)
   # puts "file_path=#{file_path}"

   # raise  unless File.exists?(file_path)
    win_lost_file=File.new(file_path,"w+")

    price_array.each_index do |back_day|
     next if back_day <number_day
     date=price_array[back_day][0]
     result=generate_win_lost_on_backday(price_array,back_day,percent,number_day)
     win_lost_file<<"#{date}##{result}\n"
    end
  
    win_lost_file.close
end

def genereate_all_symbol_win_lost(strategy_name,target_folder,percent,number_day)
	count=0
	$all_stock_list.keys.each do |symbol|
		count+=1		
		stock_file_path=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.send(strategy_name).raw_data}")
		if File.exists?(stock_file_path)
        puts "#{symbol},#{count}"
	    	generate_win_lost(strategy_name,target_folder,symbol,percent,number_day)
	    end
	end
end


#判断那些组合
def generate_all_zuhe(strategy_name)
	percent_array=[0.5,1,1.5,2,2.5,3]
	number_day=[2,3,4,5,6,7]


	percent_array.each do |percent|
		number_day.each do |num_day|
       target_sub_folder="percent_#{(percent*10).to_i}_num_#{num_day}"

         sub_folder=File.expand_path(target_sub_folder,$win_lost_path)
         Dir.mkdir(sub_folder) unless File.exists?(sub_folder)
			genereate_all_symbol_win_lost(strategy_name,target_sub_folder,percent,num_day)
		end
    end
end


if $0==__FILE__
  
   strategy_name="hundun_1"
      init_strategy_name(strategy_name)
   # daily_k_path=AppSettings.daily_k_one_day_folder
   # profit_percent=3
   # during_days=7
   # win_percent=80
   # win_count=7
   # statistic_end_date="2013-12-31"

#target_folder=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/win_lost_history",daily_k_path)
#genereate_all_symbol_win_lost(target_folder,profit_percent,during_days.to_i)
generate_all_zuhe(strategy_name)

end