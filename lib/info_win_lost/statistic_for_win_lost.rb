
require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require 'json'



def statistic_for_win_lost(folder,win_percent,win_total_number,lost_percent,lost_total_number)

	statistic_folder=File.expand_path("./win_lost_statistic/#{folder}","#{AppSettings.resource_path}")
    count=0

    buy_object_folder=File.expand_path("./buy_object/#{folder}","#{AppSettings.resource_path}")
    Dir.mkdir(buy_object_folder) unless File.exists?(buy_object_folder)

    win_buy_object_file=File.expand_path("./buy_object/#{folder}/win_percent_#{(win_percent*100).to_i}_count_#{win_total_number}.txt","#{AppSettings.resource_path}")
    lost_buy_object_file=File.expand_path("./buy_object/#{folder}/lost_percent_#{(lost_percent*100).to_i}_count_#{lost_total_number}.txt","#{AppSettings.resource_path}")

    win_target_file=File.new(win_buy_object_file,"w+")
    lost_target_file=File.new(lost_buy_object_file,"w+")
	Dir.new(statistic_folder).each do |file|
	  unless file=="." || file==".."
	  	statistic_file=File.expand_path("./win_lost_statistic/#{folder}/#{file}","#{AppSettings.resource_path}")
	  	contents_array=File.read(statistic_file).split("\n")
	  	contents_array.each do |line|
	  		result=line.split("#")
	  		array=JSON.parse(result[1])
	  		
	  	    if array[1].to_f >win_total_number &&array[3].to_f >win_percent	  	    	
	  	    	win_target_file<<file+"#"+line+"\n"	
	  	    	count+=1  	    
	  	    	puts "#{file},#{count}"	
	  	    end

	  	    if array[2].to_f >lost_total_number &&(1-array[3].to_f) >lost_percent 
                lost_target_file<<file+"#"+line+"\n"	
	  	    end
	  	end
	  end
	end
	 win_target_file.close
	 lost_target_file.close
end

if $0==__FILE__
	start=Time.now
    folder="percent_3_num_7_days"
	statistic_for_win_lost(folder,0.9,10,0.9,10)
	puts "cost=#{Time.now-start}"
end