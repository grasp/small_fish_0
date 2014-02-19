
require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def read_signal_gen(symbol)

     signal_hash=Hash.new

     signal_file=File.expand_path("./signal/#{symbol}.txt","#{AppSettings.resource_path}")

     #load file into memory
     signal_file_text=File.read(signal_file)

     #分行
     signal_file_array=signal_file_text.split("\n")

     #获取索引
     signal_keys=signal_file_array[0].gsub(/\[|\]|\"/,"").split(",")

     1.upto(signal_file_array.size-1).each do |back_day|
     # signal_array << signal_file_array[back_day].gsub(/\d|\-|\s|\[|\]|\"/,"").split(",")
     result=signal_file_array[back_day].split("#")
      key=result[0]
    

      value=result[1].gsub(/\]|\[|\"/,"").split(",")
      raise if result[1].nil?  #TBD???
      signal_hash[key]=value
     end
    # puts signal_keys
   [signal_keys, signal_hash]
end

def get_signal_zhang_in_one_day

end


if $0==__FILE__
	 a= read_signal_gen("000009.sz")
    print a[0].to_s+"\n"
    print a[1]["2013-11-01"]
end