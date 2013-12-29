require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)
require File.expand_path("../../30_signal_gen/price_will_up_down_signal.rb",__FILE__)

def calculate_file_win(buy_record_file,win_lost_history_folder,buy_record_folder,date)

	#source_file=File.expand_path("./buy_record/#{folder}/#{date}.txt","#{AppSettings.resource_path}")
  return unless File.exists?(buy_record_file)
    contents=File.read(buy_record_file).split("\n")
   #puts contents
    true_counter=0
    false_counter=0
    contents.each do |line|
      next if line.nil?
      symbol=line.split("#")[0].gsub(".txt","")

      win_lost_file=File.expand_path("./#{symbol}.txt",win_lost_history_folder)
      win_lost=File.read(win_lost_file)
      result=win_lost.match(/#{date}.*\n/).to_s
      true_counter+=1 if result.match("true")
      false_counter+=1 if result.match("false")
    end

   puts "percent on #{date} = #{true_counter.to_f/(true_counter+false_counter)}"
end

if $0==__FILE__
folder="percent_3_num_7_days"

 algorithim_path=AppSettings.hun_dun
 date="2013-11-13"
 statistic_end_date="2013-09-30"
 profit_percent=3
 duration=7
 win_count=25
 win_percent=99

 profit_percent_folder=File.expand_path("./percent_#{profit_percent}_num_#{duration}_days",algorithim_path)

 win_lost_history_folder=File.expand_path("./win_lost_history",profit_percent_folder)
 end_data_folder=File.expand_path("./end_date_#{statistic_end_date}",profit_percent_folder)
 percent_and_count_folder=File.expand_path("./percent_#{win_percent}_count_#{win_count}",end_data_folder)
 potential_buy=File.expand_path("./potential_buy",percent_and_count_folder)
 buy_record_folder=File.expand_path("./buy_record",percent_and_count_folder)
 puts "potential_buy=#{potential_buy}"



30.downto(1).each do |i|
  date = Date.new(2013, 1, -i)
 # d -= (d.wday - 5) % 7
 # puts date
  unless (date.wday==6 || date.wday==0)
  	puts date
  buy_record_file=File.expand_path("./buy_record/#{date}.txt",percent_and_count_folder)
	calculate_file_win(buy_record_file,win_lost_history_folder,buy_record_folder,date)
  end
end
end