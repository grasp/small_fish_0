 require File.expand_path("../../../../init/small_fish_init.rb",__FILE__)
 require File.expand_path("../../../0_common/common.rb",__FILE__)

def download_one_stock_history_data_from_yahoo(symbol,days,folder_path)

  exe_path=File.expand_path("../../yahoo/yahoofinance.rb",__FILE__)

  command_run="ruby #{exe_path} -z -d #{days} #{symbol}"
  result=`#{command_run}`
  raise if result.size.nil?
  #store to file  
  #symbole_file_name=File.join(lib_path.parent,"history_daily_data","#{symbol}.txt")
  symbole_file_name=File.expand_path("#{symbol}.txt",folder_path)

  puts symbole_file_name
  symbol_file=File.new(symbole_file_name,"w")
  symbol_file << result
    symbol_file.close
end

def download_all_symbol_into_history_data(folder_path,days)
count=0
$all_stock_list.keys.each do |symbol|
count+=1
#real_folder_path=File.expand_path("./#{folder_path}",$raw_path)
#Dir.mkdir(real_folder_path) unless File.exists?(real_folder_path)
#symbole_file_name=File.expand_path("../../../../resources/history_daily_data_2/#{symbol}.txt",__FILE__)
symbole_file_name=File.expand_path("./#{folder_path}/#{symbol}.txt",$raw_path)
#unless File.exists?(symbole_file_name)
puts "count=#{count}"
download_one_stock_history_data_from_yahoo(symbol,days,folder_path)
 #等待8 second 一下，避免访问太多后，不能使用
sleep 10
#end

end
end

def update_for_not_downloaded(days,folder_path)

count=0
$all_stock_list.keys.each do |symbol|
symbole_file_name=File.expand_path("./#{folder_path}/#{symbol}.txt","#{AppSettings.resource_path}")

if  File.stat(symbole_file_name).size < 2000
  download_one_stock_history_data_from_yahoo(symbol,days)
  count+=1
  sleep 15
  puts "count=#{count}" 
end

end

end


#TBD 需要区分每次下载的内容吗？避免重复下载？
def smart_download_history
  today=Time.now.to_s[0..9].to_s
  last_date_1=get_last_date_on_daily_k("000009.sz")
 # last_date_2=get_last_date_on_daily_k("000008.sz")

  diff_day= get_diff_day(today,last_date_1)
  download_all_symbol_into_history_data("history_daily_data_3",diff_day)

end

#only run if test this file
if $0 == __FILE__

#download_all_symbol_into_history_data(10000)
#download_one_stock_history_data_from_yahoo("000002.sz",10000)

result=`ipconfig`
if result.match("10.69.70.34")
 ENV['http_proxy']="http://10.140.19.49:808"
 ENV['https_proxy']="https://10.140.19.49:808"
end
start=Time.now

#download_all_symbol_into_history_data("history_daily_data_3",13)

smart_download_history
puts  "cost #{Time.now-start}"
end