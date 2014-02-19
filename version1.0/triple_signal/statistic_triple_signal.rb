require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../filter_double_signal.rb",__FILE__)
require "json"

def triple_signal_statistic(strategy,symbol)


		new_statistic=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).statistic,Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"filter_double_signal.txt")
  #unless File.exists?(new_statistic)
  	filter_double_signal(strategy,symbol)
  #end

    schema_file=File.expand_path("../signal_schema_1.txt",__FILE__)
	$schema= JSON.parse(File.read(schema_file)) #是一个数组
    end_date=Strategy.send(strategy).end_date

	signal_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")

    win_lost_file=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
   
    filtered_signal_file=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).statistic,Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"filter_double_signal.txt")

     tripple_signal_file=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).statistic,Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"triple_signal.txt")


double_signal_array=[]
triple_signal_array=[]
  File.read(filtered_signal_file).split("\n").each do |line|
    double_signal_array<<line.split("#")[0]
  end


#首先载入win lost hash
    win_lost_array=File.read(win_lost_file).split("\n")

    win_lost_hash=Hash.new
    signal_hash=Hash.new

    win_lost_array.each do |line|
    	result=line.split("#")
      if  result[0]<=end_date
    	win_lost_hash[result[0]]=result[1]
     end
    end

#载入signal _hash
   signal_array=File.read(signal_file).split("\n")
   first_line=signal_array.shift(1)[0]
   signal_keys=JSON.parse(first_line)

   #puts signal_keys
   signal_array.each do |line|
    result=line.split("#")
    temp=JSON.parse(result[1])

   temp.each_index do |index|
    	temp[index]=temp[index].to_s
    end

  if result[0]<=end_date  #只统计某个时间段的
    signal_hash[result[0]]=temp
  end
   end

 triple_statistic_hash=Hash.new

 count=0
 count1=0
 count2=0
#puts signal_hash
signal_hash.each do |date,signal_array|
	double_signal_array.each do |signal_key|
       # puts signal_key
		result=signal_key.split("_")
		#original_key=String.new(signal_key)
		a=result[0].to_i
		b=result[1].to_i
		#puts "#{a},#{b},#{result[2]}"

		if signal_array[a]+signal_array[b]==result[2]
             $schema.each_index do |index|
             	count+=1
             	new_key=""
             	new_key<<signal_key<<index.to_s<<signal_array[index]
             	if triple_statistic_hash.has_key?(new_key)
                 new_array=triple_statistic_hash[new_key]
                else
                	new_array=[0,0]
                end
             	if win_lost_hash[date]=="true"
             		count1+=1
                   new_array[0]+=1  
                else
                	count2+=1
                   new_array[1]+=1 
               end
              triple_statistic_hash[new_key]=new_array
             end
		end
	end
end

total_triple_hash=Hash.new
tripple_file=File.new(tripple_signal_file,"w+")
triple_statistic_hash.each do |key,value|
   #tripple_file<<key.to_s+value.to_s+"\n"
   total=value[0]+value[1]
   percent=value[0].to_f/total
   total_triple_hash[key]=[total,value[0],value[1],percent] if percent>=0.6
end

  total_triple_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|
  	tripple_file<<key.to_s+"#"+value.to_s+"\n"
  end


tripple_file.close
puts "count=#{count},#{count1},#{count2}"
puts triple_statistic_hash.size
end

#产生新的组合


if $0==__FILE__
	start=Time.now
	triple_signal_statistic("hundun_1","000005.sz")
	puts "cost time=#{Time.now-start}"
end