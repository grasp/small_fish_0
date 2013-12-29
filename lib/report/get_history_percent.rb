def get_history_percent(symbol)

  zuhe_file=File.expand_path("../../../resources/policy/two/#{symbol}.txt",__FILE__)
  content=File.read(zuhe_file)
  string_array=content.split("\n")
  total=string_array.size
 # puts "#{total}"

  history_percent_hash=Hash.new
  string_array.each do |line|
  	splited=line.split("#")
  	key=[[splited[0],splited[1]]]
  	key<<splited[2]
  	key<<splited[3]
  	value=splited[6]
  	history_percent_hash[key]=value
  end
history_percent_hash

end

if $0==__FILE__
	get_history_percent("000009.sz")
end