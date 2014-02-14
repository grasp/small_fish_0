require File.expand_path("../../utility/utility.rb",__FILE__)
require File.expand_path("../../batch_handle/batch_generate_buy_list.rb",__FILE__)
require File.expand_path("../../batch_handle/batch_report_win_lost_on_buy_list.rb",__FILE__)
  include StockUtility
include StockBuyRecord
batch_generate_buy_list("hundun_1")
batch_report_win_lost_on_buy_list("hundun_1")