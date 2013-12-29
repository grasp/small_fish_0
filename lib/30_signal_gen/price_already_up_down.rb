require File.expand_path("../../20_data_process/read_daily_k.rb",__FILE__)
#TBD 作为买卖信号之一
def price_already_up_down(price_hash,back_day)

end


if $0==__FILE__
	price_hash=read_daily_k_file("000009.sz")
    price_already_up_down(price_hash,1)
end