require File.expand_path("../get_history_percent.rb",__FILE__)

def guess_price(symbol)
 
 history_signal_percent=get_history_percent(symbol)

 signal_file_path=File.expand_path("../../../resources/signal/#{symbol}.txt",__FILE__)



end


if $0==__FILE__
  guess_price("000009.sz")
 
end