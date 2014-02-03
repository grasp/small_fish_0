require File.expand_path("../utility/utility.rb",__FILE__)
require File.expand_path("../utility/stock_init.rb",__FILE__)
require File.expand_path("../raw_data/stock_history_daily.rb",__FILE__)
require File.expand_path("../raw_data/stock_real_daily.rb",__FILE__)

include StockUtility
strategy_file=File.expand_path("../utility/strategy.yml",__FILE__)
strategy="hundun_1"
symbol="000004.sz"
whether_append=true

StockUtility::initialize_singl_stock_folder(strategy_file,strategy,symbol)
download_sina_real_time_and_append(strategy_file,strategy,symbol,whether_append)