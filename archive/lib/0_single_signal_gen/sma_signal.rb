require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require File.expand_path("../read_data_process.rb",__FILE__)
require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)
#判断后退几天ma 信号
##MACD 1,2,3,4,5,10,20,30,60,100,120,200
def gen_macd_signal(t_ma_array,back_day)
     return {} if t_ma_array.nil? || t_ma_array.size==0
  
   #  puts "#{t_ma_array}"

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


   # signal_hash_keys=signal_hash.keys
    signal_hash_values=signal_hash.values

    ##signal_hash_keys.each_index do |index|
    #  raise unless   signal_hash[signal_hash_keys[index]]==signal_hash_values[index]
   # end

    return signal_hash

end

def init_sma_signal
  signal_array=["t_ma2_bigger_ma5","t_ma5_bigger_ma10","t_ma5_bigger_ma20","t_ma5_bigger_ma30","t_ma5_bigger_ma60","t_ma5_bigger_ma100","t_ma5_bigger_ma120","t_ma5_bigger_ma200","t_ma10_bigger_ma20","t_ma10_bigger_ma30","t_ma10_bigger_ma60","t_ma20_bigger_ma60"]
  signal_array+=["t_ma10_bigger_ma100","t_ma10_bigger_ma120","t_ma10_bigger_ma200","t_ma20_bigger_ma30","t_ma20_bigger_ma100","t_ma20_bigger_ma120","t_ma20_bigger_ma200","t_ma30_bigger_ma60","t_ma30_bigger_ma100","t_ma30_bigger_ma120","t_ma60_bigger_ma100","t_ma60_bigger_ma120"]
  signal_array+=["t_ma60_bigger_ma200","t_ma100_bigger_ma200","t_ma120_bigger_ma200","t_ma30_bigger_ma200","t_ma100_bigger_ma120"]

    signal_array.each do |signal_name|
        signal_path=File.expand_path("./#{signal_name}",AppSettings.single_signal)
        Dir.mkdir(signal_path) unless File.exists?(signal_path)     
    end
end

def generate_sma_signal_for_one_symbol(symbol, regenerate_flag)
  signal_array=["t_ma2_bigger_ma5","t_ma5_bigger_ma10","t_ma5_bigger_ma20","t_ma5_bigger_ma30","t_ma5_bigger_ma60","t_ma5_bigger_ma100","t_ma5_bigger_ma120","t_ma5_bigger_ma200","t_ma10_bigger_ma20","t_ma10_bigger_ma30","t_ma10_bigger_ma60","t_ma20_bigger_ma60"]
  signal_array+=["t_ma10_bigger_ma100","t_ma10_bigger_ma120","t_ma10_bigger_ma200","t_ma20_bigger_ma30","t_ma20_bigger_ma100","t_ma20_bigger_ma120","t_ma20_bigger_ma200","t_ma30_bigger_ma60","t_ma30_bigger_ma100","t_ma30_bigger_ma120","t_ma60_bigger_ma100","t_ma60_bigger_ma120"]
  signal_array+=["t_ma60_bigger_ma200","t_ma100_bigger_ma200","t_ma120_bigger_ma200","t_ma30_bigger_ma200","t_ma100_bigger_ma120"]

  file_hash=Hash.new

    signal_array.each do |signal_name|
        expected_file=File.expand_path("./#{signal_name}/#{symbol}.txt",AppSettings.single_signal)
        if File.exists?(expected_file)
            if regenerate_flag==false
            # puts "#{symbol} exists, return"
             return
            end
        end
    end

    signal_array.each do |signal_name|
       # puts signal_name
        file_hash[signal_name]=File.new(File.expand_path("./#{signal_name}/#{symbol}.txt",AppSettings.single_signal),"w+")
        raise if file_hash[signal_name].nil?
    end


     #用于保存的Hash
     full_high_signal_hash={}

     #第一次数据分析以后的数据载入
     processed_data_array=read_full_data_process_file(symbol)

     #获取完成的价格hash
     price_hash=get_price_hash_from_history(symbol)
     full_price_array=price_hash.to_a
     return if full_price_array.nil? || full_price_array.size==0

     total_size=price_hash.size
     #puts full_price_array.size
     full_sma_array=processed_data_array[0].to_a
     #puts full_high_price_array.size
     return if full_sma_array.nil? || full_sma_array.size==0

     full_price_array.each_index do |index|         
       next if index==total_size-1
       date=full_price_array[index][0]  
       next if full_sma_array[index].nil?    
       signal_hash=gen_macd_signal(full_sma_array[index][1],index)

        #puts signal_hash
       signal_hash.each do |signal_name,value|
         #   puts "signal_name=#{signal_name}"
        file_hash[signal_name]<<"#{date}##{value}\n"
       end

     end

    signal_array.each do |signal_name|    
      file_hash[signal_name].close
    end
end

def generate_sma_signal_for_all_symbol(regenerate_flag)

       count=0
   init_sma_signal
    $all_stock_list.keys.each do |symbol|
        puts "#{symbol},#{count}"
        generate_sma_signal_for_one_symbol(symbol,regenerate_flag)
        count+=1
    end

end

def judge_full_macd_signal(full_macd_array, back_day,total_size)
    # print "#{full_macd_array.size},#{back_day}"
    back_day=back_day-1 if back_day==total_size-1
    judge_macd_signal(full_macd_array[back_day][1],full_macd_array[back_day+1][1],back_day)

end



if $0==__FILE__

# generate_signal_hash_for_save_file("000009.sz")
#generate_signal_hash_for_save_file("000010.sz")

  #save_analysis_result("000009.sz")

      #This file is search from TongHuaShun software installed folder

   # $all_stock_list.keys[0..100].each do |stockid|
   # generate_signal_hash_for_save_file(stockid)
#end
generate_sma_signal_for_all_symbol(true)
end