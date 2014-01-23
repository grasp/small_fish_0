require File.expand_path("../../../init/small_fish_init.rb",__FILE__)

def validate_daily_date(date)
  source_file=File.expand_path("./daily_data/#{date}.txt",$raw_data)
  return unless File.exists?(source_file)
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

def validate_each_file_on_daily_data
    source_folder=File.expand_path("./daily_data",$raw_data)
end

if $0==__FILE__
  puts __dir__
	puts validate_daily_date("2013-11-11")
end