 require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

 def generate_full_day(year)

 	utility=File.expand_path("utility",$path)
 	Dir.mkdir(utility) unless File.exists?(utility)
 	year_working_day=File.expand_path("#{year}.txt",utility)

 	unless File.exists?(year_working_day)
 	  year_working_day_file=File.new(year_working_day,"w+")

   12.downto(1).each do |j|
   31.downto(1).each do |i|
    next unless Date.valid_date?(2013, j, -i)
    date = Date.new(year, j, -i)
    unless (date.wday==6 || date.wday==0)
      year_working_day_file<<"true#"+"#{date}"+"\n"
    else
      year_working_day_file<<"false#"+"#{date}"+"\n"
   end
 end
end
 year_working_day_file.close
    end
   
 end

 def get_whether_open(year,date)
 	year_path=File.expand_path("utility/#{year}.txt",$path)
 	puts year_path
 	contents=File.read(year_path).split("\n")
 	contents.each do |line|
 		return line if line.match(date)
 	end
 end


 if $0==__FILE__
 	strategy="hundun_1"
    init_strategy_name(strategy)
    generate_full_day(2014)
    get_whether_open(2014,"2014-01-05")
 end