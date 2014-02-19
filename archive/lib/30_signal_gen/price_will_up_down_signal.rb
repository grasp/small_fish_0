require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)

#仅仅用于统计和报告

def generate_price_will_up_down(price_hash,back_day)

    puts "inside back_day=#{back_day}"

	price_will_up_down=Hash.new
    #index 0  是最新
    price_array=price_hash.to_a
    today_price_array=price_array[back_day]

   #
    if back_day<=7 #数组会越界
    today_price=price_array[back_day][1][3].to_f
    tommorrow_price=today_price.to_f
    hou_tian_price=today_price.to_f
    da_hou_tian_price=today_price.to_f
    four_days_price=today_price.to_f
    five_days_price=today_price.to_f
    six_days_price=today_price.to_f
    seven_days_price=today_price.to_f
   else
    today_price=price_array[back_day][1][3].to_f
    tommorrow_price=price_array[back_day-1][1][3].to_f
    hou_tian_price=price_array[back_day-2][1][3].to_f
    da_hou_tian_price=price_array[back_day-3][1][3].to_f
    four_days_price=price_array[back_day-4][1][3].to_f
    five_days_price=price_array[back_day-5][1][3].to_f
    six_days_price=price_array[back_day-6][1][3].to_f
    seven_days_price=price_array[back_day-7][1][3].to_f
   end

  # print [tommorrow_price,hou_tian_price,da_hou_tian_price,four_days_price,five_days_price,six_days_price,seven_days_price,today_price].to_s+"\n"

    #为简单起见，目前只加一个信号，先跑通整个框架，然后逐步加入更多想知道的
    #到底是+1还是-1？
    #print  price_array[back_day].to_s+"\n"
     #print  price_array[back_day-1]

    price_will_up_down["up_1_day"] = today_price<tommorrow_price
    price_will_up_down["up_1_day"]||=today_price<hou_tian_price
    price_will_up_down["up_1_day"]||=today_price<da_hou_tian_price
    price_will_up_down["up_1_day"]||= today_price<four_days_price
    price_will_up_down["up_1_day"]||=today_price<five_days_price
    price_will_up_down["up_1_day"]||=today_price<six_days_price
    price_will_up_down["up_1_day"]||=today_price<seven_days_price

    price_will_up_down["up_p10_after_3_day"]=((tommorrow_price-today_price)/today_price) >= 0.03
    price_will_up_down["up_p10_after_3_day"]||=((hou_tian_price-today_price)/today_price) >= 0.03
    price_will_up_down["up_p10_after_3_day"]||=((da_hou_tian_price-today_price)/today_price) >= 0.03
    price_will_up_down["up_p10_after_3_day"]||=((four_days_price-today_price)/today_price) >= 0.03
    price_will_up_down["up_p10_after_3_day"]||=((five_days_price-today_price)/today_price) >= 0.03
    price_will_up_down["up_p10_after_3_day"]||=((six_days_price-today_price)/today_price) >= 0.03
    price_will_up_down["up_p10_after_3_day"]||=((seven_days_price-today_price)/today_price) >= 0.03

   # puts price_will_up_down
	return  price_will_up_down
end




if $0==__FILE__
  	price_hash=get_price_hash_from_history("000009.sz")
    #generate_price_will_up_down(price_hash,1)
    
end