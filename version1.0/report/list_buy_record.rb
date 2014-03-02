require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)


def list_buy_record(strategy)

   report_hash=Hash.new
   report_array=[]

   $all_stock_list.keys[0..2470].each do |symbol|

       buy_record=File.join(Strategy.send(strategy).root_path,symbol,Strategy.send(strategy).statistic,\
       Strategy.send(strategy).end_date,Strategy.send(strategy).win_expect,Strategy.send(strategy).count_freq,"buy_record")
       single_name="single_#{Strategy.send(strategy).win_expect}_#{Strategy.send(strategy).single_win_freq}_#{Strategy.send(strategy).single_lost_freq}.txt"
       buy_list=File.expand_path(single_name,buy_record)

       if File.exists?(buy_list) && File.stat(buy_list).size>0
       File.read(buy_list).split("\n").each do |line|
        report_array<<symbol+"#"+line
       end
     end
  end


    report_array.each do |line|
 	     puts  line
    end

    #按照symbol 汇报

    symbol_report=Hash.new{}
    date_report=Hash.new{}

    report_array.each do |line|
      result=line.split("#")
       # print result[0]
       # line_array=
      unless  symbol_report.has_key?(result[0])
       symbol_report[result[0]]=result[1]+"_"+result[4]+"_"+result[5]
      else
        symbol_report[result[0]]+="#"+result[1]+"_"+result[4]+"_"+result[5]
      end

    end
  print "symbol_report size=#{symbol_report.size}\n"
     symbol_report.each do |key, value|
        puts "#{key},#{value}"
      end

      report_array.each do |line|
      result=line.split("#")
       # print result[0]
       # line_array=
      unless  date_report.has_key?(result[0])
       date_report[result[1]]=result[0]+"_"+result[4]+"_"+result[5]
      else
        date_report[result[1]]+="#"+result[0]+"_"+result[4]+"_"+result[5]
      end

    end
     print "date_report size=#{date_report.size}\n"
     date_report.each do |key, value|
        puts "#{key},#{value}"
      end
   
end

if $0==__FILE__
   strategy="hundun_1"
	list_buy_record(strategy)
end