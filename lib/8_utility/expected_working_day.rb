 require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

#产生交易日和非交易日的初步草稿，为人工调整打下基础
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

#判断某一年的某一天是否为交易日
 def get_whether_open(year,date)
 	year_path=File.expand_path("utility/#{year}.txt",$path)
  #如果那一年的数据还没有产生，就先产生，记得要根据放假通知，修改为false
  generate_full_day(year) unless File.exists?(year_path)
 	puts year_path
 	contents=File.read(year_path).split("\n")
 	contents.each do |line|
 		return line if line.match(date)
 	end
 end

#把工作日弄成hash
def load_working_day_into_hash(year)
  year_path=File.expand_path("utility/#{year}.txt",$path)
  working_day_hash=Hash.new
  contents=File.read(year_path).split("\n")
   contents.each do |line|
     result=line.split("#")
     working_day_hash[result[1]]=result[0]
  end
  another_hash= Hash[working_day_hash.sort_by{|key,value| key}]
  another_hash

#another_hash.to_a
end

#获取最近的交易日信息
def get_expected_working_date(year,date)
  working_day_hash=load_working_day_into_hash(year)

  if working_day_hash[date]=="true"
    puts working_day_hash[date]
    return true 
  else
    working_day_array=working_day_hash.to_a
    (working_day_array.size-1).downto(0).each do |index|
      if working_day_array[index][0]==date #这里获取到了index
        0.upto(10).each do |j|
          # puts working_day_array[index-j][1]
        if  working_day_array[index-j][1]=="true"
          puts working_day_array[index-j]
          return working_day_array[index-j][0]
        end
        end
        break
      end
    end
  end


end

#报告休市和非休市的总天数
 def report_working_day(year)
    year_path=File.expand_path("utility/#{year}.txt",$path)


    puts year_path
    true_day=0
    false_day=0

    contents=File.read(year_path).split("\n")
   contents.each do |line|
     if line.match("true")
       true_day+=1
      else
        false_day+=1
    end
  end
   puts "true_day=#{true_day},false_day=#{false_day}"
 end


 if $0==__FILE__
 	  strategy="hundun_1"
    init_strategy_name(strategy)
  #  generate_full_day(2014)
    get_whether_open(2014,"2014-01-02")
   # report_working_day(2014)
   # load_working_day_into_hash(2014)
    get_expected_working_date(2014,"2014-05-01")
 end