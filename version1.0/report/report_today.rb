require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)
require File.expand_path("../../raw_data/shi_pan.rb",__FILE__)
require File.expand_path("../../raw_data_process/shi_pan.rb",__FILE__)
require File.expand_path("../../signal/signal_shi_pan.rb",__FILE__)
require File.expand_path("../../buy_record/single_signal_shi_pan.rb",__FILE__)

include StockUtility

def need_update_or_not
	
	time = Time.now
	date=Date.today

	$working_day_hash(date.to_s)
	test_symbol="000002.sz"
	test_symbo2="600000.ss"

	last_date1=get_last_date_of_raw_date(strategy,test_symbol)
    last_date2=get_last_date_of_raw_date(strategy,test_symbo2)

    return false if last_date1==date.to_s || last_date2==date.to_s

    return false if date.to_s > last_date1 && (date.wday==6 || date.wday==0)
   
     return false if date.to_s > last_date1 && time.hour <15

     return true


end
def report_today(strategy)

	return if need_update_or_not==false

  symbol_array=$all_stock_list.keys[0..2470]
  batch_append_raw_data(strategy,symbol_array)
  batch_append_raw_data(strategy,symbol_array)
  batch_append_signal(strategy,symbol_array)

  

  #unless (date.wday==6 || date.wday==0)

  batch_handle_single_signal_buy(strategy,stock_array,date)
  

end

if $0==__FILE__
	start = Time.now
	strategy="hundun_1"
   # report_today(strategy)
    get_latest_date
	puts "cost Time #{Time.now - start }"
end
