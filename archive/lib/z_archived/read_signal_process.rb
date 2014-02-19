
def read_signal_process(symbol)

	 signal_file=File.expand_path("../../../resources/signal/#{symbol}.txt",__FILE__)
     #load file into memory
     signal_file_text=File.read(signal_file)
     #分行
     signal_file_array=signal_file_text.split("\n")
     #获取索引
     hash_keys=signal_file_array[0]

    # print signal_file_array[1]


end

def get_signal_zhang_in_one_day

end


if $0==__FILE__
	read_signal_process("000009.sz")
end