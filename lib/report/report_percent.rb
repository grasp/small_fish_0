

def report_signal_percent(symbol)

zuhe_file=File.expand_path("../../../resources/policy/two/#{symbol}.txt",__FILE__)
content=File.read(zuhe_file)
string_array=content.split("\n")
total=string_array.size
#puts "#{total}"

#80-100
#80-60
#60-50
#50-40
#40-20
#20-0
percent_count=Hash.new{0}

string_array.each do |line|
	#percent_count+=1 if line.split("#")[6].split(",")[3].to_i >percent
    percent=line.split("#")[6].split(",")[3].to_i
    percent_count["80-100"]+=1 if percent>80 && percent <=100
    percent_count["70-80"]+=1 if percent>70 && percent <=80
    percent_count["60-70"]+=1 if percent>60 && percent <=70
    percent_count["50-60"]+=1 if percent>50 && percent <=60
    percent_count["30-50"]+=1 if percent>30 && percent <=50
    percent_count["30-20"]+=1 if percent>20 && percent <=30
    percent_count["0-20"]+=1 if percent>0 && percent <=20
end
#puts percent_count

percent_count.each do |key,value|
	puts "#{key} =#{((value.to_f/total)*100).round(2)}%"
end

percent_count
end

if $0==__FILE__
  report_signal_percent("000009.sz")
end