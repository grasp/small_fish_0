将日线进行分类， 上影，下影，长短

然后自上而下的产生出报告

报告也是按照上涨预期和统计取值的范围还有结束日期这些来进行分类
==begin
 目录结构
 daily_k_one_day
  percent_3_num_7_days
    end_date_2013_12_31
      percent_95_count_10
        calculate_win
        buy_record
        potential_buy
      statistic
  win_lost_history
==end


应该包含一下几个部分
1.根据价格产生当日的日线分类
2.每日的输赢记录
2.统计一只股票的日线的输赢

基本预测

一只股票一定时间会涨多少的概率
一只股票一定时间内会跌多少的概率

高级预测1
double K  计算和统计
按照收盘价上涨预期买进，按照最高价超过百分比卖出

反过来来找呢？
列出历史上第二天上涨3%的全部股票的信号，然后发现共同点？
列出该股票第二天上涨3%的全部股票的信号，然后发现共同点

这个其实和现在的思路是一样的


信号合并
日线上涨60%的概率

单独的均价分析
列出当日均价的全部信号

单独一种信号类别分析
每个信号出现后，上涨的概率以及下跌的概率统计
两个信号的组合出现后，上涨的概率和下跌的概率
三个信号等

10个信号，那就有10+9

大盘分析
大盘信号和这些个股之间的上涨下跌关系

信号过滤
先用一类信号过滤出来百分比，
对发生次数很多的信号，一种获胜概率比较大，统计加上信号2后获胜概率有无增加

如何实现统计？
计算出当日输赢
计算出当日的两种信号，两种信号组合统计的概率

每个信号建立一个文件，date#true/false
可以自己指定信号组合
也可以计算全部组合
50个信号的2-2组合数量=（49+1）*25=7500次

daily_k和其他单个信号的组合，样本数量也就在1200左右，还是可以接受的


如何组织信号输出？
signal_A
 date#true


好处-信号部分独立的，和其他无关

最好这些信号之间有一定的独立性

原来的信号汇总统计，根据汇总来买卖


一套代码的文件夹名字用一个数字来区分
single_signal5 成为一个单独的folder
  signal_name
    symbol.txt-date#true/false
    .....

win_lost5
  end_date
    percent_2_num_5_days
     buy_by_close_sell_by_close
       date#true/false
     buy_buy_close_sell_by_high
       date#true/false



这样输赢记录也可以固定

统计部分， 依靠signal和win lost，统计概率


单信号产生
读取单个信号的当日signal
读取win lost
产生个股统计
产生全部统计


#统计单个信号的好处是可以看出单个信号的价值，为手动组合产生依据，如三信号组合
#另外，可以创造出复杂的单个信号，单独统计就有必要了

  end_date  
  single_signal_statistic
    percent_2_num_5_days
      buy_by_close_sell_by_close
        one_statistic-个股统计
        all.txt
      buy_buy_close_sell_by_high
        one_statistic
        all.txt

  one_daily_k_statistic5


   double_daily_k_statistic5


#目前设想买卖主要依赖双信号，主要想看看，结合daily k和单个信号的统计情况
   double_signal_statistic5
    one_daily_k#macd
    


   双信号产生，读取两个信号的signal
   读取win_lost
   产生个股统计
   产生全部统计


generate_signale_statistic_by_signal_and_win_lost
generate_double_signal_statistic_by_signal_win_lost(signal_path,win_lost_path,sigle_signal_statistic_folder,....)

sigle_signal
  buy_record5
   percent_2_num_5_days
    buy_by_close_sell_by_close
      percent_60_count_100
      percent_70_count_100
 

   generate_

dashboard2
  report signal_signal_statistic()
  report_calculate_win()




  














