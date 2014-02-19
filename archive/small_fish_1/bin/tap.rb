#!/usr/bin/env ruby
#coding:utf-8

require 'optparse'

options = {}
option_parser = OptionParser.new do |opts|
  # 这里是这个命令行工具的帮助信息
  opts.banner = 'Tap命令帮助信息'

  # Option 作为switch，不带argument，用于将switch设置成true或false
  options[:action] = 'download'

  # 下面第一项是Short option（没有可以直接在引号间留空），第二项是Long option，第三项是对Option的描述
  opts.on('-a', '--switch', 'download data') do
    # 这个部分就是使用这个Option后执行的代码
    options[:switch] = true   
  end


  # Option 作为flag，带argument，用于将argument作为数值解析，比如"name"信息
  #下面的“value”就是用户使用时输入的argument
  opts.on('-a ACTION', '--action Action', 'which action we want to do') do |value|
    options[:action] = value
    puts "action=#{ options[:action]}"
  end

 #symbol 参数
  opts.on('-s SYMBOL', '--symbol SYMBOL', 'symbol to download') do |value|
    options[:symbol] = value
    puts "symbol=#{ options[:symbol]}"
  end

#多长时间的参数
    opts.on('-l Length', '--length LENGTH', 'how long we need download') do |value|
    options[:length] = value
    puts "length=#{ options[:length]}"
  end

  # Option 作为flag，带一组用逗号分割的arguments，用于将arguments作为数组解析
  opts.on('-a A,B', '--array A,B', Array, 'List of arguments') do |value|
    options[:array] = value
  end

end.parse!

if options[:action]=="download"

 unless options[:symbol].nil?
 	download_yahoo_symbol_history(symbol,length)
 end

end
