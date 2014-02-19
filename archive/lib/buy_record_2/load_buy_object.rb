
require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require "json"

#could buy 是把那些潜在的可能买的都列了出来，然后根据这个列表去扫描
#603766.ss.txt#30_73falsetrue#[12, 12, 0, 1.0]
#603766.ss.txt#21_72truetrue#[11, 11, 0, 1.0]
#603766.ss.txt#4_34falsetrue#[14, 14, 0, 1.0]

def  load_buy_object_into_hash(folder,win_file)
    source_file=File.expand_path("./buy_object/#{folder}/#{win_file}.txt","#{AppSettings.resource_path}")
    contents=File.read(source_file).split("\n")
    could_buy_array=[]
    contents.each do |line|
    	result= line.split("#")
        could_buy_array<<result[0]+"#"+result[1]
    end
could_buy_array
end

##603766.ss.txt#4_34falsetrue#
def scan_signal_on_date(folder,could_buy_array,date)
    buy_record_folder=File.expand_path("./buy_record/#{folder}","#{AppSettings.resource_path}")
    Dir.mkdir(buy_record_folder) unless File.exists?(buy_record_folder)

	buy_record=File.expand_path("./buy_record/#{folder}/#{date}.txt","#{AppSettings.resource_path}")
    buy_record_file=File.new(buy_record,"w+")
    buy_record_hash=Hash.new{0}

	could_buy_array.each do |could_buy|
      result=could_buy.split("#")
      symbol=result[0]
      signal_result=result[1].match(/\d+_\d+/).to_s
      signal_index=signal_result.split("_")
      #puts signal_index

      #load symbol signal file
      source_file=File.expand_path("./signal/#{symbol}","#{AppSettings.resource_path}")
      result2= File.read(source_file).match(/#{date}.*\n/).to_s
      next if result2.nil?
      next unless result2.match("#")
      temp=result2.split("#")
      next if temp.nil?
      signal_array=JSON.parse(temp[1])
      real_signal=signal_index[0].to_s+"_"+signal_index[1].to_s+signal_array[signal_index[0].to_i].to_s+signal_array[signal_index[1].to_i].to_s
       
      buy_record_hash[symbol]+=1 if real_signal==result[1]
	end

	buy_record_hash.each do |key,value|
		buy_record_file<<"#{key}"+"#"+"#{value}"+"\n"
	end

     buy_record_file.close
end

if $0==__FILE__


 could_buy_array= load_buy_object_into_hash("percent_3_num_7_days","win_percent_90_count_10")

30.downto(1).each do |i|
  date = Date.new(2013, 11, -i)
 # d -= (d.wday - 5) % 7
 # puts date
  unless (date.wday==6 || date.wday==0)
  	puts date
    scan_signal_on_date("percent_3_num_7_days",could_buy_array,date.to_s)
  end
end
end