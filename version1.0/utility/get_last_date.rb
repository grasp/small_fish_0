require File.expand_path("../../utility/stock_init.rb",__FILE__)

#假设数据文件已经在哪里了
def get_last_date_of_raw_date(strategy,symbol)
	history_data_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data,Strategy.send(strategy).history_data,"#{symbol}.txt")
	#print history_data_path
	return nil unless  File.exists?(history_data_path)
    return nil if File.stat(history_data_path).size==0
	#读取最后5行，防止漏掉有效数据
    last_array=[]
    last_five_line=IO.readlines(history_data_path)[-5..-1]
    return nil if last_five_line.nil?
    last_five_line.each do |daily_k|
     last_array<<daily_k unless daily_k.nil?  && daily_k.length>5
    end
   # print last_array
    return last_array.last.split(",")[1]
end

def get_last_date_of_raw_process_date(strategy,symbol)
	history_data_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).raw_data_process,"#{symbol}.txt")
	return nil unless File.exists?(history_data_path)
	#读取最后5行，防止漏掉有效数据
    last_array=[]
    IO.readlines(history_data_path)[-5..-1].each do |daily_k|
     last_array<<daily_k unless daily_k.nil?  && daily_k.length>5
    end
    return last_array.last.split("#")[0]
end

def get_last_date_of_signal(strategy,symbol)
	history_data_path=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).signal_path,"#{symbol}.txt")
	return nil unless File.exists?(history_data_path)
	#读取最后5行，防止漏掉有效数据
    last_array=[]
    IO.readlines(history_data_path)[-5..-1].each do |daily_k|
      last_array<<daily_k unless daily_k.nil?  && daily_k.length>5
    end
    return last_array.last.split("#")[0]
end

def get_last_date_of_win_lost(strategy,symbol)
	history_data_path=File.join(Strategy.send(strategy).root_path,symbol,"win_lost",Strategy.send(strategy).win_expect,"#{symbol}.txt")
	return nil unless File.exists?(history_data_path)
	#读取最后5行，防止漏掉有效数据
    last_array=[]
    IO.readlines(history_data_path)[-5..-1].each do |daily_k|
     last_array<<daily_k unless daily_k.nil?  && daily_k.length>5
    end
   # print last_array
    return last_array.last.split("#")[0]
end


def check_working_day?(date)
   $working_day_hash[date]
end

def get_gap_date_array(start_date,end_date)
  return [] if start_date.nil?
   working_array= $working_day_hash.to_a
   gap_hash=Hash.new

   today=Time.now.to_s[0..9]
   current_hour=Time.now.hour

   $working_day_hash.each do |date,value|
   	if date >start_date && date <=end_date
   		gap_hash[date]=value
   	end
   end

   count=0
   gap_hash.each do |key,value|
    count+=1 if value=="true"
   end

  # puts "gap_hash size =#{gap_hash.size},count=#{count}"
  #如果是当天的gap,那就不处理
   if count==1 && gap_hash[today]=="true" && (current_hour<16 && current_hour >8)
     return []
   end

 return gap_hash.sort_by {|key,value| key}
end



if $0==__FILE__
	strategy="hundun_1"
	symbol="000005.sz"
	print get_gap_date_array("2014-01-05","2014-02-05")
end