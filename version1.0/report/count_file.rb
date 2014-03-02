require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)


def count_file(strategy)

   report_hash=Hash.new

   valid_histroy_data=0
   valid_raw_process=0
   valide_signal_file=0
   valid_win_lost=0
   valid_single_statistic=0
   valid_buy_record=0

   $all_stock_list.keys[0..2470].each do |symbol|
	  raw_data_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data,"#{symbol}.txt")
	  valid_histroy_data+=1 if File.exists?(raw_data_path) && File.stat(raw_data_path).size >0
	  #File.delete(raw_data_path) if File.stat(raw_data_path).size ==0

	  raw_process_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data_process,"#{symbol}.txt")
	  valid_raw_process+=1 if File.exists?(raw_process_path) && File.stat(raw_process_path).size >0
  
      signal_file_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
	  valide_signal_file+=1 if File.exists?(signal_file_path) && File.stat(signal_file_path).size >0

      win_lost_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).win_lost_path,Strategy.send(strategy).win_expect,"#{symbol}.txt")
      valid_win_lost+=1   if File.exists?(win_lost_path) && File.stat(win_lost_path).size >0
       single_name="single_#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).single_win_freq}_#{Strategy.send(strategy).single_lost_freq}.txt"

      single_base_statistic=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
      Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"base_statistic",single_name)

      valid_single_statistic+=1 if File.exists?(single_base_statistic) && File.stat(single_base_statistic).size >0

       buy_record=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
       Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record")
       buy_list=File.expand_path(single_name,buy_record)
       valid_buy_record+=1 if File.exists?(buy_list) && File.stat(buy_list).size >0
     
  
  #   win_lost_statistic_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
    # Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,"#{symbol}.txt")
  end
    report_hash["valid_histroy_data"]=valid_histroy_data
    report_hash["valid_raw_process"]=valid_raw_process
    report_hash["valide_signal_file"]=valide_signal_file
    report_hash["valid_win_lost"]=valid_win_lost
    report_hash["valid_single_statistic"]=valid_single_statistic
    report_hash["valid_buy_record"]=valid_buy_record 

    report_hash.each do |key,value|
 	  puts "#{value}=#{key}"
    end
end

if $0==__FILE__
   strategy="hundun_1"
	count_file(strategy)
end