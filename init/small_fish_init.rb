require File.expand_path("../config_load.rb",__FILE__)
require File.expand_path("../stock_list_init.rb",__FILE__)
require "logger"

def init_strategy_name(strategy)

#load all stock list
table_file=AppSettings.stock_list_path

Dir.mkdir(AppSettings.log_folder) unless File.exists?(AppSettings.log_folder)
$logger=Logger.new("#{AppSettings.log_path}",'daily')
$logger.level=Logger::INFO

#创建策略文件夹
Dir.mkdir(AppSettings.send(strategy).path) unless File.exists?(AppSettings.send(strategy).path)

$data_process_path=File.expand_path(AppSettings.send(strategy).data_process_path,AppSettings.send(strategy).path)
Dir.mkdir($data_process_path) unless File.exists?($data_process_path)

$signal_path=File.expand_path(AppSettings.send(strategy).signal_path,AppSettings.send(strategy).path)
Dir.mkdir($signal_path) unless File.exists?($signal_path)

$win_lost_path=File.expand_path(AppSettings.send(strategy).win_lost_path,AppSettings.send(strategy).path)
Dir.mkdir($win_lost_path) unless File.exists?($win_lost_path)

load_stock_list_file(table_file)
end

if $0==__FILE__
strategy="hundun_1"
init_strategy_name(strategy)
end