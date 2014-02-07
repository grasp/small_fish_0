require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../utility/stock_init.rb",__FILE__)

def batch_generate_win_lost_history(strategy,symbol)

#if already generated return
  win_lost_path=File.expand_path($strategy_config.win_lost_path,symbol_path)
  win_lost_file=File.join(win_lost_path,symbol)

  #
  if File.exists?(win_lost_file)
  	return if File.stat(win_lost_file).size >0
  end

  #检查history data 是否在，没有的话就是需要下载的
  


end

if $0==__FILE__
	include StockUtility
	strategy="hundun_1"
	symbol="000004.sz"
    initialize_singl_stock_folder(strategy,symbol)
	batch_generate_win_lost_history(strategy,symbol)
end