require File.expand_path("../../utility/utility.rb",__FILE__)
require "json"
def filter_double_signal(strategy,symbol)
	statistic_file= File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).statistic,Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"#{symbol}.txt")

	new_statistic=File.join(Strategy.send(strategy).root_path,symbol,\
  		Strategy.send(strategy).statistic,Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"filter_double_signal.txt")

  triple_filter=Strategy.send(strategy).triple_filter.split("_")
  happen_count=triple_filter[1].to_i
  happen_percent=triple_filter[3].to_f

  puts "happen_count=#{happen_count},happen_percent=#{happen_percent}"

   puts "statistic_file=#{statistic_file}"
    raise unless File.exists?(statistic_file)

	new_statistic_file=File.new(new_statistic,"w+")

   statistic_hash=Hash.new

	File.read(statistic_file).split("\n").each do |line|
		result=line.split("#")
		statistic_hash[result[0]]=JSON.parse(result[1])
	end

  
	new_hash=Hash.new

	 statistic_hash.sort_by {|_key,_value| _value[2]}.reverse.each do |key,value|
	 	new_hash[key]=value
	 end
puts "statistic_hash size= #{statistic_hash.size},new_hash size=#{new_hash.size}"
	 new_hash.each do |key,value|
	 	new_statistic_file<<"#{key}"+"#"+"#{value}" +"\n" if value[1]>happen_count && value[3]*100>happen_percent
	 end
new_statistic_file.close
end

if $0==__FILE__

	strategy="hundun_1"
	filter_double_signal(strategy,"000004.sz")
end