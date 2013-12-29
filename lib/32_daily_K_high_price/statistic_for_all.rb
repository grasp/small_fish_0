
require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require "json"

def statistic_for_all(folder)

   source_folder=File.expand_path("./daily_k_statistic/#{folder}","#{AppSettings.resource_path}")
   total_hash=Hash.new
   new_array=[]

   Dir.new(source_folder).each do |file|

   	puts file
    if file!="." && file!=".."
      source_file=File.expand_path("./daily_k_statistic/#{folder}/#{file}","#{AppSettings.resource_path}")

      contents=File.read(source_file).split("\n")

   	  contents.each do |line|
   		result=line.split("#")
   		next if result[1].nil?
   		temp_array=JSON.parse(result[1])
   		key=result[0]

   		if total_hash.has_key?(key)
   		  total_hash[key][0]+=temp_array[1].to_i
   		  total_hash[key][1]+=temp_array[2].to_i
   	    else
   	    	total_hash[key]=[temp_array[1].to_i,temp_array[2].to_i]
   	    end   		

   	end      
   	end
end
#puts total_hash
target_file=File.expand_path("./daily_k_total/#{folder}/all.txt","#{AppSettings.resource_path}")

total_hash.each do |key,value|
	total=value[0]+value[1]
	win_percent=(value[0].to_f/total.to_f).round(2)
    total_hash[key]=[total,value[0],value[1],win_percent]
end

#写入到文件中
temp_file=File.new(target_file,"w+")

total_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|
	temp_file<<key.to_s+"#"+value.to_s+"\n"
end

temp_file.close
return total_hash
end


def statistic_all_daily_k(daily_k_path,profit_percent,during_days,win_percent,win_count,statistic_end_date)

    source_folder=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/end_date_#{statistic_end_date}/one_statistic",daily_k_path)
    target_file=File.expand_path("./percent_#{profit_percent}_num_#{during_days}_days/end_date_#{statistic_end_date}/all_statistic/all.txt",daily_k_path)
    return if File.exists?(target_file)
    total_hash=Hash.new
    new_array=[]

    Dir.new(source_folder).each do |file|
    puts "#{file} statistic done"
    if file!="." && file!=".."
      source_file=File.expand_path("./#{file}",source_folder)
      contents=File.read(source_file).split("\n")

      contents.each do |line|
      result=line.split("#")
      next if result[1].nil?
      temp_array=JSON.parse(result[1])
      key=result[0]

      if total_hash.has_key?(key)
        total_hash[key][0]+=temp_array[1].to_i
        total_hash[key][1]+=temp_array[2].to_i
        else
          total_hash[key]=[temp_array[1].to_i,temp_array[2].to_i]
        end       

    end      
    end
end
#puts total_hash

total_hash.each do |key,value|
  total=value[0]+value[1]
  win_percent=(value[0].to_f/total.to_f).round(2)
    total_hash[key]=[total,value[0],value[1],win_percent]
end

#写入到文件中
temp_file=File.new(target_file,"w+")

total_hash.sort_by {|_key,_value| _value[3]}.reverse.each do |key,value|
  temp_file<<key.to_s+"#"+value.to_s+"\n"
end

temp_file.close
return total_hash

end
if $0==__FILE__
	folder="percent_3_num_1_days"
    statistic_for_all(folder)
end