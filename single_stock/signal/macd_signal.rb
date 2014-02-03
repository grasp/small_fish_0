require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../utility/read_raw_data_process.rb",__FILE__)

module StockSignal
    include StockUtility

#判断后退几天ma 信号
##MACD 1,2,3,4,5,10,20,30,60,100,120,200
def judge_macd_signal(t_ma_array,y_ma_array,back_day)

	#t_ma_array=[]
	#full_macd_array[back_day][1].each {|i| t_ma_array<<i.to_f}#当天的macd数组
  
	#y_ma_array=[]
	#full_macd_array[back_day+1][1].each {|i| y_ma_array<<i.to_f}#上一天的macd数组

    #puts "t_ma_array=#{t_ma_array}"
    #puts "y_ma_array=#{y_ma_array}"
    signal_hash=Hash.new
#  从今日数组中产生的信号
    signal_hash["t_ma2_bigger_ma5"]=t_ma_array[1] > t_ma_array[4]
    signal_hash["t_ma5_bigger_ma10"]=t_ma_array[4]  > t_ma_array[5]
    signal_hash["t_ma5_bigger_ma20"]=t_ma_array[4]  > t_ma_array[6]
    signal_hash["t_ma5_bigger_ma30"]=t_ma_array[4]  > t_ma_array[7]
    signal_hash["t_ma5_bigger_ma60"]=t_ma_array[4]  > t_ma_array[8]
    signal_hash["t_ma5_bigger_ma100"]=t_ma_array[4] > t_ma_array[9]
    signal_hash["t_ma5_bigger_ma120"]=t_ma_array[4] > t_ma_array[10]
    signal_hash["t_ma5_bigger_ma200"]=t_ma_array[4] > t_ma_array[11]
    signal_hash["t_ma10_bigger_ma20"]=t_ma_array[5] > t_ma_array[6]
    signal_hash["t_ma10_bigger_ma30"]=t_ma_array[5] > t_ma_array[7]
    signal_hash["t_ma10_bigger_ma60"]=t_ma_array[5] > t_ma_array[8]
    signal_hash["t_ma10_bigger_ma100"]=t_ma_array[5] > t_ma_array[9]
    signal_hash["t_ma10_bigger_ma120"]=t_ma_array[5] > t_ma_array[10]
    signal_hash["t_ma10_bigger_ma200"]=t_ma_array[5] > t_ma_array[11]
    signal_hash["t_ma20_bigger_ma30"]=t_ma_array[6] > t_ma_array[7]
    signal_hash["t_ma20_bigger_ma60"]=t_ma_array[6] > t_ma_array[8]
    signal_hash["t_ma20_bigger_ma100"]=t_ma_array[6] > t_ma_array[9]
    signal_hash["t_ma20_bigger_ma120"]=t_ma_array[6] > t_ma_array[10]
    signal_hash["t_ma20_bigger_ma200"]=t_ma_array[6] > t_ma_array[11]
    signal_hash["t_ma30_bigger_ma60"]=t_ma_array[7] > t_ma_array[8]
    signal_hash["t_ma30_bigger_ma100"]=t_ma_array[7] > t_ma_array[9]
    signal_hash["t_ma30_bigger_ma120"]=t_ma_array[7] > t_ma_array[10]
    signal_hash["t_ma30_bigger_ma200"]=t_ma_array[7] > t_ma_array[11]
    signal_hash["t_ma60_bigger_ma100"]=t_ma_array[8] > t_ma_array[9]
    signal_hash["t_ma60_bigger_ma120"]=t_ma_array[8] > t_ma_array[10]
    signal_hash["t_ma60_bigger_ma200"]=t_ma_array[8] > t_ma_array[11]
    signal_hash["t_ma100_bigger_ma120"]=t_ma_array[9] > t_ma_array[10]
    signal_hash["t_ma100_bigger_ma200"]=t_ma_array[9] > t_ma_array[11]
    signal_hash["t_ma120_bigger_ma200"]=t_ma_array[10] > t_ma_array[11]

 #  从昨日数组中产生的信号
    signal_hash["y_ma2_bigger_ma5"]=y_ma_array[1]   > y_ma_array[4]
    signal_hash["y_ma5_bigger_ma10"]=y_ma_array[4]  > y_ma_array[5]
    signal_hash["y_ma5_bigger_ma20"]=y_ma_array[4]  > y_ma_array[6]
    signal_hash["y_ma5_bigger_ma30"]=y_ma_array[4]  > y_ma_array[7]
    signal_hash["y_ma5_bigger_ma60"]=y_ma_array[4]  > y_ma_array[8]
    signal_hash["y_ma5_bigger_ma100"]=y_ma_array[4] > y_ma_array[9]
    signal_hash["y_ma5_bigger_ma120"]=y_ma_array[4] > y_ma_array[10]
    signal_hash["y_ma5_bigger_ma200"]=y_ma_array[4] > y_ma_array[11]
    signal_hash["y_ma10_bigger_ma20"]=y_ma_array[5] > y_ma_array[6]
    signal_hash["y_ma10_bigger_ma30"]=y_ma_array[5] > y_ma_array[7]
    signal_hash["y_ma10_bigger_ma60"]=y_ma_array[5] > y_ma_array[8]
    signal_hash["y_ma10_bigger_ma100"]=y_ma_array[5] > y_ma_array[9]
    signal_hash["y_ma10_bigger_ma120"]=y_ma_array[5] > y_ma_array[10]
    signal_hash["y_ma10_bigger_ma200"]=y_ma_array[5] > y_ma_array[11]
    signal_hash["y_ma20_bigger_ma30"]=y_ma_array[6] > y_ma_array[7]
    signal_hash["y_ma20_bigger_ma60"]=y_ma_array[6] > y_ma_array[8]
    signal_hash["y_ma20_bigger_ma100"]=y_ma_array[6] > y_ma_array[9]
    signal_hash["y_ma20_bigger_ma120"]=y_ma_array[6] > y_ma_array[10]
    signal_hash["y_ma20_bigger_ma200"]=y_ma_array[6] > y_ma_array[11]
    signal_hash["y_ma30_bigger_ma60"]=y_ma_array[7] > y_ma_array[8]
    signal_hash["y_ma30_bigger_ma100"]=y_ma_array[7] > y_ma_array[9]
    signal_hash["y_ma30_bigger_ma120"]=y_ma_array[7] > y_ma_array[10]
    signal_hash["y_ma30_bigger_ma200"]=y_ma_array[7] > y_ma_array[11]
    signal_hash["y_ma60_bigger_ma100"]=y_ma_array[8] > y_ma_array[9]
    signal_hash["y_ma60_bigger_ma120"]=y_ma_array[8] > y_ma_array[10]
    signal_hash["y_ma60_bigger_ma200"]=y_ma_array[8] > y_ma_array[11]
    signal_hash["y_ma100_bigger_ma120"]=y_ma_array[9] > y_ma_array[10]
    signal_hash["y_ma100_bigger_ma200"]=y_ma_array[9] > y_ma_array[11]
    signal_hash["y_ma120_bigger_ma200"]=y_ma_array[10] > y_ma_array[11]

  #比较今日和昨日的均线数组得到的信号
    signal_hash["t_ma2_bigger_y_ma2"]=t_ma_array[1]   > y_ma_array[1]
    signal_hash["t_ma3_bigger_y_ma3"]=t_ma_array[2]   > y_ma_array[2]
    signal_hash["t_ma4_bigger_y_ma5"]=t_ma_array[3]   > y_ma_array[3]
    signal_hash["t_ma5_bigger_y_ma5"]=t_ma_array[4]   > y_ma_array[4]
    signal_hash["t_ma10_bigger_y_ma10"]=t_ma_array[5]   > y_ma_array[5]
    signal_hash["t_ma20_bigger_y_ma20"]=t_ma_array[6]   > y_ma_array[6]
    signal_hash["t_ma30_bigger_y_ma30"]=t_ma_array[7]   > y_ma_array[7]
    signal_hash["t_ma60_bigger_y_ma60"]=t_ma_array[8]   > y_ma_array[8]
    signal_hash["t_ma100_bigger_y_ma100"]=t_ma_array[9]   > y_ma_array[9]
    signal_hash["t_ma120_bigger_y_ma120"]=t_ma_array[10]   > y_ma_array[10]
    signal_hash["t_ma200_bigger_y_ma200"]=t_ma_array[11]   > y_ma_array[11]

    signal_hash_keys=signal_hash.keys
    signal_hash_values=signal_hash.values

    signal_hash_keys.each_index do |index|
      raise unless   signal_hash[signal_hash_keys[index]]==signal_hash_values[index]
    end

    return signal_hash

end

def judge_full_macd_signal(full_macd_array, back_day,total_size)
    # print "#{full_macd_array.size},#{back_day}"
    back_day=back_day-1 if back_day==total_size-1
    judge_macd_signal(full_macd_array[back_day][1],full_macd_array[back_day+1][1],back_day)

end
end


if $0==__FILE__
    include StockSignal
    generate_signal_hash_for_save_file(stockid)

end