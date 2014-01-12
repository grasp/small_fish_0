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

def calculate_file_win_by_strategy(strategy,date)

    buy_record_file=File.expand_path("#{date}.txt",$buy_record)
   # puts buy_record_file
     return unless File.exists?(buy_record_file)
     return if  File.stat(buy_record_file).size==0

    contents=File.read(buy_record_file).split("\n")
    true_counter=0
    false_counter=0
    contents.each do |line|
     # puts line
      next if line.nil?
     #puts line
      symbol=line.split("#")[0].gsub(".txt","")
      win_lost_file=File.expand_path("./#{AppSettings.send(strategy).win_expect}/#{symbol}.txt",$win_lost_path)

      win_lost=File.read(win_lost_file)
      result=win_lost.match(/#{date}.*\n/).to_s
      true_counter+=1 if result.match("true")
      false_counter+=1 if result.match("false")
    end
 result= "percent on #{date} = #{true_counter.to_f/(true_counter+false_counter)}"
 puts result
return result
end

def calculate_all_day_in_future(strategy)
   init_strategy_name(strategy)
   strategy_result=File.expand_path("#{strategy}.txt",$count_freq)
   strategy_result_file=File.new(strategy_result,"w+")
 puts "start"
   12.downto(1).each do |j|
   30.downto(1).each do |i|
    next unless Date.valid_date?(2013, j, -i)
    date = Date.new(2013, j, -i)
    unless (date.wday==6 || date.wday==0)
    result=calculate_file_win_by_strategy(strategy,date)
    puts result="#{result}"
    strategy_result_file<<result +"\n" unless result.nil?
   end
 end
end
strategy_result_file.close
end

if $0==__FILE__
 date="2013-11-13"
 start=Time.now
 strategy="hundun_2"
 init_strategy_name(strategy)
  calculate_all_day_in_future(strategy)
end