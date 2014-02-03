
require File.expand_path("../utility.rb",__FILE__)
require File.expand_path("../stock_init.rb",__FILE__)
require File.expand_path("../stock_history_daily.rb",__FILE__)
require File.expand_path("../stock_real_daily.rb",__FILE__)

class Stock
include StockUtility
attr_reader:strategy
attr_reader:yahoo_symbol

	def initialize(strategy_file, strategy,symbol)
	     @strategy_file=strategy_file
         @strategy=strategy
         @yahoo_symbol=symbol
         initialize_singl_stock_folder(strategy_file,strategy,symbol)
	end

    #如何避免重复下载
	def download_history_daily
       download_yahoo_history(@strategy_file, @strategy,@yahoo_symbol)
	end

	def download_real_time_daily

	end

	def raw_data_process

	end

	def signal_process

	end

	def win_lost_process

	end

	def double_signal_process

	end

	def generate_buy_record

	end

	def calculate_win_lost

	end

	def generate_buy_record_on_date
		puts @strategy
      # sent_email("hunter.wxhu@gmail.com","test","hello world!")
	end

end

if $0==__FILE__
	strategy_file=File.expand_path("../strategy.yml",__FILE__)
	stock=Stock.new(strategy_file,"hundun_1","000002.sz")
	puts stock.yahoo_symbol
	stock.generate_buy_record_on_date
end