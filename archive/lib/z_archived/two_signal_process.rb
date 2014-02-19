
require File.expand_path("../split_signal_into_win_lost.rb",__FILE__)
require File.expand_path("../get_zuhe.rb",__FILE__)

def guess_policy(symbol,will_key)

	result_path=File.expand_path("./signal_process/two/#{will_key}/#{symbol}.txt","#{AppSettings.resource_path}")

   # puts result_path
	policy_report  =File.new(result_path,"w+")

	# puts policy_report

    signal_result=read_signal_gen(symbol)

	signal_hash=signal_result[1]
	signal_keys=signal_result[0]

#将信号分成输赢两组
	result=split_signal_into_win_lost(symbol,will_key)

	win_signal_array=result[1]
	win_lost_array=result[2]

	price_hash=get_price_hash_from_history(symbol)

	#产生所有的组合
	index_array=get_all_possible_zuhe2(signal_keys.size) 
  puts "index array size=#{index_array.size}"
    #生成的报告Hash
	report_hash=Hash.new
  report_key=[]
  index_count=0
 #统计每个组合的输赢次数
 start=Time.now
 index_array.each do |one_zuhe|

  index_count+=1
  total_occur=0
 	puts "#{index_count},cost=#{Time.now-start}" if (index_count % 1000)==0
  
 	#先统计赢的
 	win_signal_array.each do |win_signal|
 	report_key=[]
 	#首先产生组合键值
 	report_key<<one_zuhe

 	#value_compo=""
    #增加值作为键值
	one_zuhe.each do |eachindex| 
		#puts "eachindex=#{eachindex}"
		#puts win_signal[eachindex]
		report_key<<win_signal[eachindex]
	end
    #report_key+=value_compo
   # report_key<<value_compo
   unless report_hash.has_key?(report_key)
    report_hash[report_key]=[0,0,0,0,0] 
     total_occur=1
  # else
    # total_occur+=1
    end
    report_hash[report_key][0]+=1
    report_hash[report_key][1]+=1
    #report_hash[report_key][2]+=1
    end

    #再统计输的
    #先统计赢的
 	win_lost_array.each do |win_lost|
    next if win_lost.nil?
    report_key=[]
 	#首先产生组合键值
 	#report_key=one_zuhe.to_s
 	report_key<<one_zuhe
 	#value_compo=""
    #增加值作为键值
	one_zuhe.each { |eachindex| report_key<<win_lost[eachindex]}
   # report_key+=value_compo
  unless report_hash.has_key?(report_key)
    report_hash[report_key]=[0,0,0,0,0] 
    total_occur=1
  end
    report_hash[report_key][0]+=1
    #report_hash[report_key][1]+=1
    report_hash[report_key][2]+=1
    end
 end

 report_hash.each do |key,value|
 	value[3]=cal_per(value[1],value[2])
	value[4]=cal_per(value[2],value[1])
 end


 report_hash.sort_by {|_key,_value| _value[3].to_i}.reverse.each do |key,value|
		policy_report<<key.join("#")+"#"+"#{signal_keys[key[0][0]]}"+"#"+"#{signal_keys[key[0][1]]}"+"#"+value.to_s+"\n"
	end

  policy_report.close
   
end

def test_generae_signal_report_on_one_stock(symbol)
     start=Time.now
    guess_policy(symbol,"up_p10_after_3_day")
    puts "cost time=#{Time.now-start}"
end

def test_generae_signal_report_on_multiple_stock(will_key)

    count=0
    $all_stock_list.keys.each do |stock_id|
      source_path=File.expand_path("./signal/#{stock_id}.txt","#{AppSettings.resource_path}")
      result_path=File.expand_path("./policy/two/#{will_key}/#{stock_id}.txt","#{AppSettings.resource_path}")

      if (not File.exists?(result_path)) && File.exists?(source_path) 
        test_generae_signal_report_on_one_stock(stock_id)
      end
   end
end
if $0==__FILE__
   test_generae_signal_report_on_multiple_stock("up_p10_after_3_day")
   #test_generae_signal_report_on_one_stock("000009.sz")
end