require File.expand_path("../../20_data_process/read_daily_price_volume.rb",__FILE__)



#hash 的值为几个基本数据，依次为开盘，最高，最低，收盘，成交量
def generate_daily_k_signal_one_day(symbol)
    price_hash=get_price_hash_from_history(symbol)
    daily_k_path=File.expand_path("./daily_k/#{symbol}.txt","#{AppSettings.resource_path}")
    daily_k_file=File.new(daily_k_path,"w+")
    
    price_hash.each do |date,array|
    	next if array[0].to_f==0.0
    	next if array.size<3         
        # puts  "#{win_percent},#{zheng_fu_percent},#{shang_ying_percent},#{xia_ying_percent}"
         #puts zheng_fu_percent
         daily_k_file<<date+"#"+generate_daily_k_signal_on_date(price_hash,date).to_s+"\n"
    end

   daily_k_file.close
end

def generate_daily_k_signal_on_target_folder(target_folder,symbol)
    price_hash=get_price_hash_from_history(symbol)
    daily_k_path=File.expand_path("./#{symbol}.txt",target_folder)
    daily_k_file=File.new(daily_k_path,"w+")
    
    price_hash.each do |date,array|
        next if array[0].to_f==0.0
        next if array.size<3         
        # puts  "#{win_percent},#{zheng_fu_percent},#{shang_ying_percent},#{xia_ying_percent}"
         #puts zheng_fu_percent
         daily_k_file<<date+"#"+generate_daily_k_signal_on_date(price_hash,date).to_s+"\n"
    end

   daily_k_file.close

end

def generate_daily_k_signal_on_date(price_hash,date)

        array=price_hash[date]
        raise if array.nil?

        win=array[3].to_f-array[0].to_f

         if win > 0
             shang_ying=array[1].to_f-array[3].to_f
             xia_ying=down=array[0].to_f-array[2].to_f
         else
             shang_ying=array[1].to_f-array[0].to_f
             xia_ying=down=array[3].to_f-array[2].to_f
         end

         total_lenth=array[1].to_f-array[2].to_f
         total_lenth=0.001 if total_lenth==0
         win_percent=((win/total_lenth)*10).round(0)
         shang_ying_percent=((shang_ying/total_lenth)*10).round(0)
         xia_ying_percent=((xia_ying/total_lenth)*10).round(0)

         zheng_fu_percent=((total_lenth/array[0].to_f)*100).round(0)

         zheng_fu_percent >10 ? zheng_fu_percent_flag="high" :  zheng_fu_percent_flag="low"
        # puts [win_percent,shang_ying_percent,xia_ying_percent,zheng_fu_percent_flag]
         [win_percent,shang_ying_percent,xia_ying_percent,zheng_fu_percent_flag].to_s
end

def generate_all
    count=0
    $all_stock_list.keys.each do |symbol|
        daily_k_path=File.expand_path("./daily_k/#{symbol}.txt","#{AppSettings.resource_path}")
        price_file=File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}")
       # if (not File.exists?(daily_k_path)) && File.exists?(File.expand_path("./history_daily_data/#{symbol}.txt","#{AppSettings.resource_path}"))
           #unless File.exists?(daily_k_path)
             if File.exists?(price_file)
               generate_daily_k_signal_one_day(symbol)
               puts "#{symbol},#{count+=1}"
           #end
        end
    end
end

if $0==__FILE__
	 #generate_daily_k_signal_one_day("000009.sz")
     #generate_all
      price_hash=get_price_hash_from_history("000009.sz")
      generate_daily_k_signal_on_date(price_hash,"2013-11-02")
end