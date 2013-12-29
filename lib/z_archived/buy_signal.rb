require 'settingslogic'
require File.expand_path("../read_data_process.rb",__FILE__)

class BuySettings < Settingslogic
source File.expand_path("../buy_policy_1.yml",__FILE__)
end

class SellSettings < Settingslogic
source File.expand_path("../sell_policy_1.yml",__FILE__)
 # source File.expand_path("../buy_policy_1.yml",__FILE__)
end

#bpc :buy policy class
#依次为开盘，最高，最低，收盘，成交量
def generate_price_buy_signal(price_array,bpc)
	buy_signal=true

	#开盘价大于收盘价
	if bpc.respond_to?("price")
	 buy_signal &&=bpc.price.open_bigger_close  == (price_array[0].to_f > price_array[3].to_f) if  bpc.price.respond_to?("open_bigger_close")
     #开盘价为最高价
	 buy_signal &&=bpc.price.open_equal_high  == (price_array[0].to_f == price_array[1].to_f) if  bpc.price.respond_to?("open_equal_high")
	 #开盘价为最低价
	 buy_signal &&=bpc.price.open_equal_low  == (price_array[0].to_f == price_array[2].to_f) if   bpc.price.respond_to?("open_equal_low")
     #收盘价为最低价
     buy_signal &&=bpc.price.close_equal_low  == (price_array[3].to_f == price_array[2].to_f) if  bpc.price.respond_to?("close_equal_low")
     #收盘价为最高价
     buy_signal &&=bpc.price.close_equal_high  == (price_array[3].to_f == price_array[1].to_f) if  bpc.price.respond_to?("close_equal_high ")
    
     end
      buy_signal
end

#MACD 1,2,3,4,5,10,20,30,60,100,120,200
def generate_macd_buy_signal(macd_array,bpc,date)
    #print "today macd5_bigger_macd10"+macd_array[4,2].to_s+"#{bpc.macd.macd5_bigger_macd10}"+"\n"
 # puts date


	buy_signal=true
	if bpc.respond_to?("macd")
	 buy_signal &&=bpc.macd.macd2_bigger_macd5  == (macd_array[1].to_f > macd_array[4].to_f) if  bpc.macd.respond_to?("macd2_bigger_macd5")
  	 buy_signal &&=bpc.macd.macd5_bigger_macd10  == (macd_array[4].to_f > macd_array[5].to_f) if  bpc.macd.respond_to?("macd5_bigger_macd10")
     buy_signal &&=bpc.macd.macd5_bigger_macd20  == (macd_array[4].to_f > macd_array[6].to_f) if  bpc.macd.respond_to?("macd5_bigger_macd20")
     buy_signal &&=bpc.macd.macd5_bigger_macd30  == (macd_array[4].to_f > macd_array[7].to_f) if  bpc.macd.respond_to?("macd5_bigger_macd30")
     buy_signal &&=bpc.macd.macd5_bigger_macd60  == (macd_array[4].to_f > macd_array[8].to_f) if  bpc.macd.respond_to?("macd5_bigger_macd60")
     buy_signal &&=bpc.macd.macd5_bigger_macd100  == (macd_array[4].to_f > macd_array[9].to_f) if  bpc.macd.respond_to?("macd5_bigger_macd100")
     buy_signal &&=bpc.macd.macd5_bigger_macd120  == (macd_array[4].to_f > macd_array[10].to_f) if  bpc.macd.respond_to?("macd5_bigger_macd120")
     buy_signal &&=bpc.macd.macd5_bigger_macd200  == (macd_array[4].to_f > macd_array[11].to_f) if  bpc.macd.respond_to?("macd5_bigger_macd200")
     buy_signal &&=bpc.macd.macd10_bigger_macd20  == (macd_array[5].to_f > macd_array[6].to_f) if  bpc.macd.respond_to?("macd10_bigger_macd20")
     buy_signal &&=bpc.macd.macd10_bigger_macd30  == (macd_array[5].to_f > macd_array[7].to_f) if  bpc.macd.respond_to?("macd10_bigger_macd30")
     buy_signal &&=bpc.macd.macd10_bigger_macd60  == (macd_array[5].to_f > macd_array[8].to_f) if  bpc.macd.respond_to?("macd10_bigger_macd60")
     buy_signal &&=bpc.macd.macd10_bigger_macd100  == (macd_array[5].to_f > macd_array[9].to_f) if  bpc.macd.respond_to?("macd10_bigger_macd100")
     buy_signal &&=bpc.macd.macd10_bigger_macd120  == (macd_array[5].to_f > macd_array[10].to_f) if  bpc.macd.respond_to?("macd10_bigger_macd120")
     buy_signal &&=bpc.macd.macd10_bigger_macd200 == (macd_array[5].to_f > macd_array[11].to_f) if  bpc.macd.respond_to?("macd10_bigger_macd200")
     buy_signal &&=bpc.macd.macd20_bigger_macd30  == (macd_array[6].to_f > macd_array[7].to_f) if  bpc.macd.respond_to?("macd20_bigger_macd30")
     buy_signal &&=bpc.macd.macd20_bigger_macd60  == (macd_array[6].to_f > macd_array[8].to_f) if  bpc.macd.respond_to?("macd20_bigger_macd60")
     buy_signal &&=bpc.macd.macd20_bigger_macd100  == (macd_array[6].to_f > macd_array[9].to_f) if  bpc.macd.respond_to?("macd20_bigger_macd100")
     buy_signal &&=bpc.macd.macd20_bigger_macd120  == (macd_array[6].to_f > macd_array[10].to_f) if  bpc.macd.respond_to?("macd20_bigger_macd120")
     buy_signal &&=bpc.macd.macd20_bigger_macd200  == (macd_array[6].to_f > macd_array[11].to_f) if  bpc.macd.respond_to?("macd20_bigger_macd200")    
    end

   # puts "macd buy_singal=#{buy_signal} on #{date}" if date=="2013-05-06"
  buy_signal
end

#MACD 1,2,3,4,5,10,20,30,60,100,120,200
def generate_last_macd_buy_signal(macd_array,bpc,date)
     # print "last macd5_bigger_macd10"+macd_array[4,2].to_s+"#{bpc.macd.macd5_bigger_macd10}"+"\n"
	buy_signal=true
	if bpc.respond_to?("last_macd")
	 buy_signal &&=bpc.last_macd.macd2_bigger_macd5  == (macd_array[1].to_f > macd_array[4].to_f) if  bpc.last_macd.respond_to?("macd2_bigger_macd5")
  	 buy_signal &&=bpc.last_macd.macd5_bigger_macd10  == (macd_array[4].to_f > macd_array[5].to_f) if  bpc.last_macd.respond_to?("macd5_bigger_macd10")
     buy_signal &&=bpc.last_macd.macd5_bigger_macd20  == (macd_array[4].to_f > macd_array[6].to_f) if  bpc.last_macd.respond_to?("macd5_bigger_macd20")
     buy_signal &&=bpc.last_macd.macd5_bigger_macd30  == (macd_array[4].to_f > macd_array[7].to_f) if  bpc.last_macd.respond_to?("macd5_bigger_macd30")
     buy_signal &&=bpc.last_macd.macd5_bigger_macd60  == (macd_array[4].to_f > macd_array[8].to_f) if  bpc.last_macd.respond_to?("macd5_bigger_macd60")
     buy_signal &&=bpc.last_macd.macd5_bigger_macd100  == (macd_array[4].to_f > macd_array[9].to_f) if  bpc.last_macd.respond_to?("macd5_bigger_macd100")
     buy_signal &&=bpc.last_macd.macd5_bigger_macd120  == (macd_array[4].to_f > macd_array[10].to_f) if  bpc.last_macd.respond_to?("macd5_bigger_macd120")
     buy_signal &&=bpc.last_macd.macd5_bigger_macd200  == (macd_array[4].to_f > macd_array[11].to_f) if  bpc.last_macd.respond_to?("macd5_bigger_macd200")
     buy_signal &&=bpc.last_macd.macd10_bigger_macd20  == (macd_array[5].to_f > macd_array[6].to_f) if  bpc.last_macd.respond_to?("macd10_bigger_macd20")
     buy_signal &&=bpc.last_macd.macd10_bigger_macd30  == (macd_array[5].to_f > macd_array[7].to_f) if  bpc.last_macd.respond_to?("macd10_bigger_macd30")
     buy_signal &&=bpc.last_macd.macd10_bigger_macd60  == (macd_array[5].to_f > macd_array[8].to_f) if  bpc.last_macd.respond_to?("macd10_bigger_macd60")
     buy_signal &&=bpc.last_macd.macd10_bigger_macd100  == (macd_array[5].to_f > macd_array[9].to_f) if  bpc.last_macd.respond_to?("macd10_bigger_macd100")
     buy_signal &&=bpc.last_macd.macd10_bigger_macd120  == (macd_array[5].to_f > macd_array[10].to_f) if  bpc.last_macd.respond_to?("macd10_bigger_macd120")
     buy_signal &&=bpc.last_macd.macd10_bigger_macd200 == (macd_array[5].to_f > macd_array[11].to_f) if  bpc.last_macd.respond_to?("macd10_bigger_macd200")
     buy_signal &&=bpc.last_macd.macd20_bigger_macd30  == (macd_array[6].to_f > macd_array[7].to_f) if  bpc.last_macd.respond_to?("macd20_bigger_macd30")
     buy_signal &&=bpc.last_macd.macd20_bigger_macd60  == (macd_array[6].to_f > macd_array[8].to_f) if  bpc.last_macd.respond_to?("macd20_bigger_macd60")
     buy_signal &&=bpc.last_macd.macd20_bigger_macd100  == (macd_array[6].to_f > macd_array[9].to_f) if  bpc.last_macd.respond_to?("macd20_bigger_macd100")
     buy_signal &&=bpc.last_macd.macd20_bigger_macd120  == (macd_array[6].to_f > macd_array[10].to_f) if  bpc.last_macd.respond_to?("macd20_bigger_macd120")
     buy_signal &&=bpc.last_macd.macd20_bigger_macd200  == (macd_array[6].to_f > macd_array[11].to_f) if  bpc.last_macd.respond_to?("macd20_bigger_macd200")    
    end
   # puts "last_buy_signal=#{buy_signal}"
  buy_signal
end

#  low price array [1,2,3,4,5,10,20,30,60,100,120]
def generate_low_price_buy_signal(low_price_array,price_array,bpc)
	buy_signal=true
	if bpc.respond_to?("low_price")
	  buy_signal &&=bpc.low_price.lowest_5_day  == (low_price_array[4].to_f < price_array[3].to_f) if  bpc.low_price.respond_to?("lowest_5_day")
      buy_signal &&=bpc.low_price.lowest_10_day  == (low_price_array[5].to_f < price_array[3].to_f) if  bpc.low_price.respond_to?("lowest_10_day")
      buy_signal &&=bpc.low_price.lowest_20_day  == (low_price_array[6].to_f < price_array[3].to_f) if  bpc.low_price.respond_to?("lowest_20_day")
      buy_signal &&=bpc.low_price.lowest_30_day  == (low_price_array[7].to_f < price_array[3].to_f) if  bpc.low_price.respond_to?("lowest_30_day")
      buy_signal &&=bpc.low_price.lowest_60_day  == (low_price_array[8].to_f < price_array[3].to_f) if  bpc.low_price.respond_to?("lowest_60_day")
      buy_signal &&=bpc.low_price.lowest_100_day  == (low_price_array[9].to_f < price_array[3].to_f) if  bpc.low_price.respond_to?("lowest_100_day")
      buy_signal &&=bpc.low_price.lowest_120__day  == (low_price_array[10].to_f < price_array[3].to_f) if  bpc.low_price.respond_to?("lowest_120_day")
    end
    buy_signal
end

#  high price array [1,2,3,4,5,10,20,30,60,100,120]
def generate_high_price_buy_signal(high_price_array,price_array,bpc)
    buy_signal=true
	if bpc.respond_to?("high_price")
	  buy_signal &&=bpc.high_price.highest_5_day  == (high_price_array[4].to_f < price_array[3].to_f) if  bpc.high_price.respond_to?("highest_5_day")
      buy_signal &&=bpc.high_price.highest_10_day  == (high_price_array[5].to_f < price_array[3].to_f) if  bpc.high_price.respond_to?("highest_10_day")
      buy_signal &&=bpc.high_price.highest_20_day  == (high_price_array[6].to_f < price_array[3].to_f) if  bpc.high_price.respond_to?("highest_20_day")
      buy_signal &&=bpc.high_price.highest_30_day  == (high_price_array[7].to_f < price_array[3].to_f) if  bpc.high_price.respond_to?("highest_30_day")
      buy_signal &&=bpc.high_price.highest_60_day  == (high_price_array[8].to_f < price_array[3].to_f) if  bpc.high_price.respond_to?("highest_60_day")
      buy_signal &&=bpc.high_price.highest_100_day  == (high_price_array[9].to_f < price_array[3].to_f) if  bpc.high_price.respond_to?("highest_100_day")
      buy_signal &&=bpc.high_price.highest_120__day  == (high_price_array[10].to_f < price_array[3].to_f) if  bpc.high_price.respond_to?("highest_120_day")
    end
    buy_signal
end

#   [1,2,3,4,5,10,20,30,60,100,120]
def generate_volume_buy_signal(volume_array,bpc)

	 buy_signal=true
	 if bpc.respond_to?("volume")
	   buy_signal &&=bpc.volume.volume2_bigger_volume5  == (volume_array[1].to_f > volume_array[4].to_f) if  bpc.volume.respond_to?("volume2_bigger_volume5")
  	   buy_signal &&=bpc.volume.volume5_bigger_volume10  == (volume_array[4].to_f > volume_array[5].to_f) if  bpc.volume.respond_to?("volume5_bigger_volume10")
       buy_signal &&=bpc.volume.volume5_bigger_volume20  == (volume_array[4].to_f > volume_array[6].to_f) if  bpc.volume.respond_to?("volume5_bigger_volume20")
       buy_signal &&=bpc.volume.volume5_bigger_volume30  == (volume_array[4].to_f > volume_array[7].to_f) if  bpc.volume.respond_to?("volume5_bigger_volume30")
       buy_signal &&=bpc.volume.volume5_bigger_volume60  == (volume_array[4].to_f > volume_array[8].to_f) if  bpc.volume.respond_to?("volume5_bigger_volume60")
       buy_signal &&=bpc.volume.volume5_bigger_volume100  == (volume_array[4].to_f > volume_array[9].to_f) if  bpc.volume.respond_to?("volume5_bigger_volume100")
     end
     buy_signal
end



#to judge the buy or sell_singal based on back day
#0->price hash,1->macd_hash,2->low price hash,3->high price hash,4->volume hash

def generate_buy_signal(processed_data,back_day,buy_policy_class,date)
     
     #puts "hihihi"
     buy_signal=true
     price_hash=processed_data[0]
     macd_hash=processed_data[1]
     low_price_hash=processed_data[2]
     high_price_hash=processed_data[3]
     volume_hash=processed_data[4]

     full_price_array=price_hash.to_a

     date=full_price_array[back_day][0]
     #puts "first date=#{date},index=#{index}"
     price_array=full_price_array[back_day][1]

     macd_array=macd_hash[date]
     low_price_array=low_price_hash[date]
     high_price_array=high_price_hash[date]
     volume_array=volume_hash[date]
     #puts "last price =#{price_array[27]}"
     # 需要加1， 而不是减1
     last_date=full_price_array[back_day+1][0]
     last_price=full_price_array[back_day+1][1]
    # puts "last date=#{last_date}" if date=="2013-05-06"
     last_macd_array=macd_hash[last_date]
     last_low_price_array=low_price_hash[last_date]
     last_high_price_array=high_price_hash[last_date]
     last_volume_array=volume_hash[last_date]

     price_signal = generate_price_buy_signal(price_array,buy_policy_class)
     macd_signal = generate_macd_buy_signal(macd_array,buy_policy_class,date)
     last_macd_signal = generate_last_macd_buy_signal(last_macd_array,buy_policy_class,last_date)
     low_price_signal = generate_low_price_buy_signal(low_price_array,price_array,buy_policy_class)
     high_price_signal = generate_high_price_buy_signal(high_price_array,price_array,buy_policy_class)
     volume_signal = generate_volume_buy_signal(volume_array,buy_policy_class)
    
   
     buy_signal=(price_signal && macd_signal && last_macd_signal && low_price_signal && high_price_signal && volume_signal)
     # puts "macd_singal=#{macd_signal},last_macd_signal=#{last_macd_signal},buy_signal=#{buy_signal} " if buy_signal==true
      puts "buy on #{date}" if buy_signal==true
     return buy_signal
end

#for generate signal by sell policy class
def generate_sell_signal(processed_data,back_day,sell_policy_class,date)
     
     sell_signal=true
     price_hash=processed_data[0]
     macd_hash=processed_data[1]
     low_price_hash=processed_data[2]
     high_price_hash=processed_data[3]
     volume_hash=processed_data[4]

     full_price_array=price_hash.to_a

     date=full_price_array[back_day][0]
     #puts "first date=#{date},index=#{index}"
     price_array=full_price_array[back_day][1]

     macd_array=macd_hash[date]
     low_price_array=low_price_hash[date]
     high_price_array=high_price_hash[date]
     volume_array=volume_hash[date]
        #puts "last price =#{price_array[27]}"
     last_date=full_price_array[back_day+1][0]
     last_price=full_price_array[back_day+1][1]
     last_macd_array=macd_hash[last_date]
     last_low_price_array=low_price_hash[last_date]
     last_high_price_array=high_price_hash[last_date]
     last_volume_array=volume_hash[last_date]

     price_signal = generate_price_buy_signal(price_array,sell_policy_class)
     macd_signal = generate_macd_buy_signal(macd_array,sell_policy_class,date)
     last_macd_signal = generate_last_macd_buy_signal(last_macd_array,sell_policy_class,date)
     low_price_signal = generate_low_price_buy_signal(low_price_array,price_array,sell_policy_class)
     high_price_signal = generate_high_price_buy_signal(high_price_array,price_array,sell_policy_class)
     volume_signal = generate_volume_buy_signal(volume_array,sell_policy_class)
    
     sell_signal=price_signal && macd_signal && last_macd_signal && low_price_signal && high_price_signal && volume_signal
        
     return sell_signal
end


if $0==__FILE__

    def get_all_buy_signal(symbol)
        processed_data_array=read_data_process_file(symbol)
        puts "processed_data_array[0].size=#{processed_data_array[0].size}"
        buy_policy_class=BuySettings.new(File.expand_path("../buy_policy_1.yml",__FILE__))
        price_hash=processed_data_array[0]
        full_price_array=price_hash.to_a
        back_day=price_hash.size
        buy_counter =0
        win_counter=0
        lost_counter=0

        (back_day-2).downto(1).each do |index|
          #  next if full_price_array[index][0].nil?
          buy_signal=generate_buy_signal(processed_data_array,index,buy_policy_class,"date")
          if buy_signal==true
          buy_counter+=1 
          full_price_array[index-3][1][3]>full_price_array[index][1][3] ?   win_counter+=1 : lost_counter+=1
          end
        end

        puts "buy_counter=#{buy_counter},win_counter=#{win_counter},lose counter=#{lost_counter}"
    end
get_all_buy_signal("000009.sz")

end