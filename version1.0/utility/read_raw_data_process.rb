
require File.expand_path("../../utility/utility.rb",__FILE__)
module StockUtility
def read_full_data_process_file(straty_name,symbol)

 processed_file=File.join(Strategy.send(straty_name).root_path,symbol,Strategy.send(straty_name).raw_data_process,"#{symbol}.txt")

  return [] unless File.exists?(processed_file)

  price_hash={}
  macd_hash={}
  low_price_hash={}
  high_price_hash={}
  volume_hash={}
  
 content_array=File.read(processed_file).split("\n")
#新的先处理
content_array.reverse.each do |line|

 	result_array=line.strip.split("#")
 	if  result_array.size>4
   	date=result_array[0]
    macd_hash[date]=result_array[1].gsub(/\[|\]|\"/,"").split(",")
    low_price_hash[date]=result_array[2].gsub(/\[|\]|\"/,"").split(",")
    high_price_hash[date]=result_array[3].gsub(/\[|\]|\"/,"").split(",")
    volume_hash[date]=result_array[4].gsub(/\[|\]|\"/,"").split(",")
end
 end

# puts "macd_hash size=#{macd_hash.size}"
# puts "low_price_hash=#{low_price_hash.size}"
# puts "high_price_hash=#{high_price_hash.size}"
# puts "volume_hash=#{volume_hash.size}"
 [macd_hash,low_price_hash,high_price_hash,volume_hash]
end



def read_processed_data_on_backday(straty_name,symbol,back_day)
  processed_file=File.join(Strategy.send(straty_name).root_path,symbol,Strategy.send(straty_name).raw_data_process,"#{symbol}.txt")

  contents_array=File.read(processed_file).split("\n")
  needed_line_array=contents_array.reverse[back_day].split("#")
   # puts needed_line_array

  macd_array=needed_line_array[1].gsub(/\[|\]/,"").split(",")
  low_price_array=needed_line_array[2].gsub(/\[|\]/,"").split(",")
  high_price_array=needed_line_array[3].gsub(/\[|\]/,"").split(",")
  volume_array=needed_line_array[4].gsub(/\[|\]/,"").split(",")

 [macd_array,low_price_array,high_price_array,volume_array]


end
end

if $0==__FILE__
  include StockUtility
  strategy="hundun_1"
 read_full_data_process_file(strategy,"000004.sz")
# print   read_processed_data_on_backday("000009.sz",0)
end