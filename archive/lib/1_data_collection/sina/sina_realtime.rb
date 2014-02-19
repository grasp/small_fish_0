require 'net/http' 
require 'ostruct' 

  



def sina_get_realtime_data_for_one_stock(stock_number)

#proxy_addr="10.140.19.49"
#proxy_port="808"

proxy_addr=""
proxy_port=""


#response= Net::HTTP.get("hq.sinajs.cn","/list=sh601566" )

#proxy_addr="10.140.19.49"
#proxy_port="808"

#proxy_addr=nil
#proxy_port=nil

#Net::HTTP.new('hq.sinajs.cn', "/list=sh601566", proxy_addr, proxy_port).start { |http|
   
 #  result= http.response
#}

end


def get_sina_real_time_data_without_proxy(stock_number)
   
	response= Net::HTTP.get("hq.sinajs.cn","/list=#{stock_number}" )
	#puts response
	return response.split(",")


#begin
 # file = open("some_file")
#rescue
#  file = STDIN
#end

end


#！！！发现和google以及yahoo出入很大，而google  yahoo和同花顺是类似的，难道新浪不靠谱？
#依次为Date,开盘，最高，最低，收盘，成交量
def parse_sina_result_to_yahoo(result_array)

	#puts result_array
	yahoo_array=[]
	yahoo_array<< result_array[30]
    yahoo_array<< result_array[1]
    yahoo_array<< result_array[4]
    yahoo_array<< result_array[5]
    yahoo_array<< result_array[3]
    yahoo_array<< (result_array[8].to_i/100)
    yahoo_array<< result_array[3]
yahoo_array
end

if $0==__FILE__
  result_array=get_sina_real_time_data_without_proxy("sz000509")

  puts result_array
 # puts parse_sina_result_to_yahoo(result_array)
end
