require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
require 'json'

def potential_buy(symbol,algorithim_path,date,statistic_end_date,profit_percent,duration,win_count,win_percent,lost_percent,lost_counter)

   folder="percent_#{profit_percent}_num_#{duration}_days"
   folder2="percent_#{win_percent}_count_#{win_count}"

   potential_buy_folder=File.expand_path("./#{folder}/end_date_#{statistic_end_date}/#{folder2}/potential_buy",algorithim_path)
   statistic_file=File.expand_path("./#{folder}/end_date_#{statistic_end_date}/statistic/#{symbol}.txt",algorithim_path)
   
   potential_buy_path=File.expand_path("./#{symbol}.txt",potential_buy_folder)
   potential_buy_file=File.new(potential_buy_path,"w+")

  if File.exists?(statistic_file)
    puts "handle #{symbol}"
     contents=File.read(statistic_file).split("\n")
     contents.each do |line|
     win_lost=JSON.parse(line.split("#")[1])
     potential_buy_file<<line+"\n"  if ((win_lost[3].to_f)*100 >win_percent) && ((win_lost[1].to_f)>win_count)
     #potential_buy_file<<line+"\n" if ((1-win_lost[3].to_f)*100 >lost_percent) && ((win_lost[2].to_f)>lost_counter)
    # print [win_lost[3],1-win_lost[3].to_f,win_percent,lost_percent].to_s
     end
  end
  potential_buy_file.close
  File.delete(potential_buy_file) if File.stat(potential_buy_file).size==0
end

def generate_all_potential_buy(algorithim_path,date,statistic_end_date,profit_percent,duration,win_count,win_percent,lost_percent,lost_counter)
   #will_folder_path=File.expand_path("./potential_buy/#{folder}","#{AppSettings.resource_path}")

  # Dir.mkdir(will_folder_path) unless File.exists?(will_folder_path)
   count=0
   $all_stock_list.keys.each do |symbol|
   	count+=1
   	puts "#{symbol},#{count}"
   	potential_buy(symbol,algorithim_path,date,statistic_end_date,profit_percent,duration,win_count,win_percent,lost_percent,lost_counter)
   end
end


def potential_buy_all_symbol(strategy)

  match_result=AppSettings.send(strategy).count_freq.scan(/\d\d/)
  win_count=match_result[0].to_i
  win_percent=match_result[1].to_i
count=0
 $all_stock_list.keys.each do |symbol|
  count+=1
  puts "start #{symbol},count=#{count}"
   # 首先获取统计路径
   # statistic_path=File.expand_path(AppSettings.send(strategy).win_expect,$end_date_path)
    statistic_result_file=File.expand_path("#{symbol}.txt",$statistic_file_path)
    potential_buy_list=File.expand_path("./statistic_result/#{symbol}.txt",$count_freq)
    potential_buy=File.new(potential_buy_list,"w+")
   # puts statistic_result_file

    if File.exists?(statistic_result_file)
    contents=File.read(statistic_result_file).split("\n")
     contents.each do |line|
     win_lost=JSON.parse(line.split("#")[1])
     if ((win_lost[3].to_f)*100 >=win_percent) && ((win_lost[1].to_f)>=win_count)
         potential_buy<< line+"\n"
      end


     #potential_buy_file<<line+"\n" if ((1-win_lost[3].to_f)*100 >lost_percent) && ((win_lost[2].to_f)>lost_counter)
    # print [win_lost[3],1-win_lost[3].to_f,win_percent,lost_percent].to_s
     end
     potential_buy.close
     File.delete(potential_buy_list) if File.stat(potential_buy_list).size==0
    end
  end
end

if $0==__FILE__

 start=Time.now
 strategy="hundun_2"
 init_strategy_name(strategy)
 #potential_buy_symbol(strategy,"000002.sz")
 potential_buy_all_symbol(strategy)
 puts "cost=#{Time.now-start}"

end