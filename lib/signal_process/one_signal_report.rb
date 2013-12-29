
require File.expand_path("../split_signal.rb",__FILE__)
require File.expand_path("../get_zuhe.rb",__FILE__)
def guess_policy(symbol,will_key)

	result_path=File.expand_path("../../../resources/policy/#{symbol}.txt",__FILE__)
   # puts result_path
	policy_report  =File.new(result_path,"w+")

	# puts policy_report

    signal_result=read_signal_process(symbol)

	signal_array=signal_result[1]
	signal_keys=signal_result[0]

#将信号分成输赢两组
	result=split_signal_by_will_key(symbol,will_key)
	win_signal_array=result[1]
	win_lost_array=result[2]

	price_hash=read_daily_k_file(symbol)

	#产生所有的组合
	index_array=get_all_possible_zuhe1(signal_keys.size)

    #生成的报告Hash
	report_hash=Hash.new
    report_key=""

 #统计每个组合的输赢次数
 index_array.each do |one_zuhe|
 	#先统计赢的
 	win_signal_array.each do |win_signal|

 	#首先产生组合键值
 	report_key=one_zuhe.to_s
 	value_compo=""
    #增加值作为键值
	one_zuhe.each { |eachindex| value_compo+=win_signal[eachindex]}
    report_key+=value_compo
    report_hash[report_key]=[0,0,0,0,0] unless report_hash.has_key?(report_key)
    report_hash[report_key][0]+=1
    report_hash[report_key][1]+=1
    end

    #再统计输的
    #先统计赢的
 	win_lost_array.each do |win_signal|

 	#首先产生组合键值
 	report_key=one_zuhe.to_s
 	value_compo=""
    #增加值作为键值
	one_zuhe.each { |eachindex| value_compo+=win_signal[eachindex]}
    report_key+=value_compo
    report_hash[report_key]=[0,0,0,0,0] unless report_hash.has_key?(report_key)
    report_hash[report_key][0]+=1
    report_hash[report_key][2]+=1
    end

 end

 report_hash.each do |key,value|
 	value[3]=cal_per(value[1],value[2])
	value[4]=cal_per(value[2],value[1])
 end


 report_hash.sort_by {|_key,_value| _value[3].to_i}.each do |key,value|
  #  report_hash.sort_by {|a1,a2| a2[1][1].to_i <=> a1[1][1].to_i}.each do |key,value|
		
	#	value[3]=cal_per(value[1],value[2])
	#	value[4]=cal_per(value[2],value[1])
		policy_report<<key.to_s+"#{signal_keys[key.match(/\d+/).to_s.to_i]}"+"#"+value.to_s+"\n"
	end

    policy_report.close
   
end

if $0==__FILE__
    guess_policy("000009.sz","up_1_day")
end