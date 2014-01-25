require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

#
def validate_daily_date(date)

  source_file=File.expand_path("./daily_data/#{date}.txt",$raw_data)
  puts source_file
  return false unless File.exists?(source_file)
  contents=File.read(source_file).split("\n")

  count=0
  contents.each do |line|
  	count+=1 if line.match(/#0\.0/)
  end

  $logger.info("daily data contents.size=#{contents.size},unconsistent count=#{count}")

  if (contents.size==2471) && (count < 300)
      $logger.error("validate daily data pass")
    return true 
  else
    File.delete(source_file)#!!!!delete the source_file
     $logger.error("#{source_file} is invalid, deleted")
    return false
  end

end



if $0==__FILE__
  puts __dir__
  strategy="hundun_1"
  init_strategy_name(strategy)
	validate_daily_date("2014-01-24")
end