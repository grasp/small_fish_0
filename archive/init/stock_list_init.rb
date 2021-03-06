
def load_stock_list_file(stock_list_file)

raise unless File.exist?(stock_list_file)

tong_hua_shun_stock_list_file=stock_list_file

all_stock_list=Hash.new
sh_stock_name_list=Hash.new
sz_stock_name_list=Hash.new
zhongxiao_stock_name_list=Hash.new
chuangye_stock_name_list=Hash.new

count=0

File.open(tong_hua_shun_stock_list_file,"r").each do |line|
  newline=line.force_encoding("utf-8")
  code=newline.match(/^\d\d\d\d\d\d/).to_s.force_encoding("utf-8")
  name=newline.match(/\D+/).to_s.force_encoding("utf-8")

 puts "Warn:#{code} without name!!" if name.nil?

#only handle those 600,000,002,300 catogory.

  if code.match(/^60\d\d\d\d/)
  	code=code+".ss"
  	sh_stock_name_list[code]=name
  	all_stock_list[code]=name
  elsif code.match(/^000\d\d\d/)
  	code=code+".sz"
  	sz_stock_name_list[code]=name
  	all_stock_list[code]=name
  elsif code.match(/^002\d\d\d/)
  code=code+".sz"
  zhongxiao_stock_name_list[code]=name
  all_stock_list[code]=name
elsif code.match(/^300\d\d\d/)
	code=code+".sz"
	chuangye_stock_name_list[code]=name
	all_stock_list[code]=name
else
  end
  count+=1
end

puts "total stock=#{count}\rsh main stock :#{sh_stock_name_list.size}\r\
sz main stock:#{sz_stock_name_list.size}\rsz zhongxiao stock:#{zhongxiao_stock_name_list.size}\r\
sz chuangye stock:#{chuangye_stock_name_list.size}"

#now save hash to database	
#all_stock_list.each do |stock_id,stock_name|
 # $redis.hset("stock_name_list",stock_id,stock_name)  #remember how your save data here
#end
$all_stock_list=all_stock_list
return all_stock_list
end




if $0 == __FILE__
  #This file is search from TongHuaShun software installed folder
  #table_file=File.join(Pathname.new(__FILE__).parent.parent.parent,"resources","stock_table_2013_10_01.txt")
  table_file=File.expand_path("../../../resources/stock_list/stock_table_2013_10_01.txt",__FILE__)
  stock_list=load_stock_list_file(table_file)
end




