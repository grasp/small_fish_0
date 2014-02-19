#这个文件汇报截至日期到现在为止，按照某种策略买卖后，按照既定输赢的比例
#并且报告每天操作的股票数量

#那些因素和报告有关呢？
#1. 截至日期
#2. 盈利预期
#3. 发生次数

# 信号文件夹，输赢文件夹，统计文件夹
require File.expand_path("../../../init/small_fish_init.rb",__FILE__)
def report_win_percent(strategy_name)

	#如果没有买卖记录，那么就先产生买卖记录
   puts AppSettings.hundun_1


end

if __FILE__==$0
	strategy_name="hundun_1"
	report_win_percent(strategy_name)
end