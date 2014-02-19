
require File.expand_path("../split_signal_into_win_lost.rb",__FILE__)
require File.expand_path("../get_zuhe.rb",__FILE__)

def statisitc_on_one_zuhe(report_hash,index1,index2,value1,value2)
     report_key=index1.to_s+"#"+index2.to_s+"#"+value1+"#"+value2     
     report_hash.has_key?(report_key) ? report_hash[report_key]+=1 : report_hash[report_key]=0
end


def  calculate_one_processed_signal(symbol,will_key)
    result_path=File.expand_path("./signal_process/two/#{will_key}/#{symbol}.txt","#{AppSettings.resource_path}")

    # puts result_path
    policy_report  =File.new(result_path,"w+")


    #将信号分成输赢两组
    result=split_signal_into_win_lost(symbol,will_key)
   
    signal_keys=result[0]
    win_signal_array=result[1]
    win_lost_array=result[2]
    win_size=win_signal_array.size
    lost_size=win_lost_array.size

     index_array=get_all_possible_zuhe2(signal_keys.size) 
     win_hash=Hash.new{0}
     lost_hash=Hash.new{0}
     report_hash=Hash.new{0}

#计算赢的
     index_array.each do |one_zuhe|
      0.upto(win_size-1).each do |i|
       a=one_zuhe[0]
       b=one_zuhe[1]
       next if a==b
        statisitc_on_one_zuhe(win_hash,a,b,win_signal_array[i][a],win_signal_array[i][b])
     end
     end

#计算输掉的
    index_array.each do |one_zuhe|
      0.upto(lost_size-1).each do |i|
       a=one_zuhe[0]
       b=one_zuhe[1]
        next if a==b
        statisitc_on_one_zuhe(lost_hash,a,b,win_lost_array[i][a],win_lost_array[i][b])
     end
     end

     win_hash.each do |key,value|
      report_hash[key]=[value,0]
    end

    lost_hash.each do |key,value|
       report_hash[key][0]>0  ? report_hash[key][1]=value : report_hash[key]=[0,value]       
    end
    new_hash=Hash.new

    report_hash.each do |key,value|
      total=value[0]+value[1]
      win_percent=cal_per(value[0],value[1])
      lost_percent=cal_per(value[1],value[0])
      new_hash[key]=[total,value[0],value[1],win_percent,lost_percent]
    end
     
     #现在保存到文件
   new_hash.sort_by {|_key,_value| _value[3].to_i}.reverse.each do |key,value|

    key_array=key.split("#")
  #  puts "key=#{key},"+"#{signal_keys[key_array[2].to_i]}"+"#"+"#{signal_keys[key_array[3].to_i]}"
    #puts "#{key_array[0].to_i},#{key_array[1].to_i}"
    policy_report<<key+"#"+"#{signal_keys[key_array[0].to_i]}"+"#"+"#{signal_keys[key_array[1].to_i]}"+"#"+value.to_s+"\n"
  end

   policy_report.close

end

def test_generae_signal_report_on_one_stock(symbol)
     start=Time.now
    calculate_one_processed_signal(symbol,"up_p10_after_3_day")
    puts "cost time=#{Time.now-start}"
end

def test_generae_signal_report_on_multiple_stock(will_key)

    count=0
    $all_stock_list.keys.each do |stock_id|
      source_path=File.expand_path("./signal/#{stock_id}.txt","#{AppSettings.resource_path}")
      result_path=File.expand_path("./signal_process/two/#{will_key}/#{stock_id}.txt","#{AppSettings.resource_path}")

      if (not File.exists?(result_path)) && File.exists?(source_path) 
        test_generae_signal_report_on_one_stock(stock_id)
      end
   end
end
if $0==__FILE__
  start=Time.now
   test_generae_signal_report_on_multiple_stock("up_p10_after_3_day")
   #test_generae_signal_report_on_one_stock("000009.sz")
   #new_loop("000009.sz","up_p10_after_3_day")

   puts "cost time=#{Time.now-start}"
end