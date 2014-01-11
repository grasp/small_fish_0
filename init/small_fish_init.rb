require File.expand_path("../config_load.rb",__FILE__)
require File.expand_path("../stock_list_init.rb",__FILE__)
require "logger"

def init_strategy_name(strategy)

#load all stock list
table_file=AppSettings.stock_list_path

Dir.mkdir(AppSettings.send(strategy).log_folder) unless File.exists?(AppSettings.send(strategy).log_folder)

$logger=Logger.new("#{AppSettings.send(strategy).log_path}",'daily')
$logger.level=Logger::INFO

#创建策略文件夹
Dir.mkdir(AppSettings.send(strategy).path) unless File.exists?(AppSettings.send(strategy).path)

$data_process_path=File.expand_path(AppSettings.send(strategy).data_process_path,AppSettings.send(strategy).path)
Dir.mkdir($data_process_path) unless File.exists?($data_process_path)

$signal_path=File.expand_path(AppSettings.send(strategy).signal_path,AppSettings.send(strategy).path)
Dir.mkdir($signal_path) unless File.exists?($signal_path)

$win_lost_path=File.expand_path(AppSettings.send(strategy).win_lost_path,AppSettings.send(strategy).path)
Dir.mkdir($win_lost_path) unless File.exists?($win_lost_path)

$statistic_path=File.expand_path(AppSettings.send(strategy).statistic_path,AppSettings.send(strategy).path)
Dir.mkdir($statistic_path) unless File.exists?($statistic_path)



$end_date_path=File.expand_path(AppSettings.send(strategy).end_date,$statistic_path)
Dir.mkdir($end_date_path) unless File.exists?($end_date_path)

$win_expect=File.expand_path(AppSettings.send(strategy).win_expect,$end_date_path)
Dir.mkdir($win_expect) unless File.exists?($win_expect)

$statistic_file_path=File.expand_path("statistic_result",$win_expect)
Dir.mkdir($statistic_file_path) unless File.exists?($statistic_file_path)

$count_freq=File.expand_path(AppSettings.send(strategy).count_freq,$win_expect)
Dir.mkdir($count_freq) unless File.exists?($count_freq)

$counter_statistic_path=File.expand_path("statistic_result",$count_freq)
Dir.mkdir($counter_statistic_path) unless File.exists?($counter_statistic_path)


$buy_record=File.expand_path(AppSettings.send(strategy).buy_record,$count_freq)
Dir.mkdir($buy_record) unless File.exists?($buy_record)

load_stock_list_file(table_file)
end

if $0==__FILE__
 strategy="hundun_1"
 init_strategy_name(strategy)
end