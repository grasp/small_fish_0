
require File.expand_path("../../../../init/small_fish_init.rb",__FILE__)
 require File.expand_path("../../../0_common/common.rb",__FILE__)
require "json"

def append_daily_data_into_history(date)
  #检查日期对不对
   last_date1=get_last_date_on_daily_k("000009.sz")
   last_date2=get_last_date_on_daily_k("000008.sz")
   last_date=""
   last_date1<last_date2 ? last_date=last_date1 : last_date=last_date2

  if last_date==date
    return -1
  end

  Time.now.monday? ? max_diff_day=3 : max_diff_day=1
  return -1 if get_diff_day(date,last_date) > max_diff_day


  sina_data_hash=Hash.new
  yahoo_data_hash=Hash.new
 # folder_path=File.expand_path("./daily_data/#{date}","#{AppSettings.resource_path}")

  daily_data_path=File.expand_path("./daily_data/#{date}.txt",$raw_data)

  puts daily_data_path
  raise unless File.exists?(daily_data_path)

  contents_array=File.read(daily_data_path).split("\n")
  count=0
  contents_array.each do |daily_data|
    count+=1
   # puts "count=#{count}"
  	result=daily_data.split("#")
  	#result[0] 是代号
    #print result.to_s+"\n"
  	key=result[0]
  	result.shift(1)
  	#print result
    sina_data_hash[key]=result
  end

  #转换成yahoo格式
 
  sina_data_hash.each do |key,value|
  	#puts key
  	new_key=key[2..8]+".ss" if key.match("sh")
  	new_key=key[2..8]+".sz" if key.match("sz")
 
  	yahoo_data_hash[new_key]=value
  end

    new_array=[]
    yahoo_data_hash.each do |key,value|
    	symbol=key
      #print value.to_s+"\n"
      new_array[0]=value[0]
      new_array[1]=value[1]
      new_array[2]=value[2]
      new_array[3]=value[3]
      new_array[4]=value[4]
      new_array[6]=value[6]
      new_array[5]=((value[5].to_i)*100).to_s #sina and yahoo is different
    #	puts "start #{symbol},#{value[5]},#{new_array[5]},#{((value[5].to_i)*100).to_s}"
    	history_data_path=File.expand_path("./history_daily_data/#{symbol}.txt",$raw_data)

    	#防止重复写入同一天数据到历史文件
    if File.exists?(history_data_path)
    	unless File.read(history_data_path).match(value[0]) #原来的文件不包含这个日期
    	  history_data_file=File.new(history_data_path,"a+")
    	  history_data_file<<new_array.join("#")+"\n" unless (new_array[5]==0||new_array[0]==0)#停牌的自动不写进入
    	  history_data_file.close
      end
    end
    end #end of yahoo data hash 

end

def appened_today_daily_data
  today=Time.now.to_s[0..9]
  #避免重复导入，先查看下最新日期
  last_date=get_last_date_on_daily_k("000009.sz")

  puts "last_date=#{last_date}"
  if last_date==today
    return -1
  end

  Time.now.monday? ? max_diff_day=3 : max_diff_day=1
  puts "max_diff_day=#{max_diff_day}"


  return -1 if get_diff_day(today,last_date) > max_diff_day

  append_daily_data_into_history(today)
  return 0
end


if $0==__FILE__
    start=Time.now
	 # append_daily_data_into_history("2013-11-08")
    #appened_today_data
    strategy="hundun_1"
    init_strategy_name(strategy)
    append_daily_data_into_history("2014-01-23")
    puts "cost #{Time.now-start}"
end