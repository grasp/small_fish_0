 start=Time.now
 require 'settingslogic'
 require 'sqlite3'
 require 'active_record'


 require File.expand_path("../stock_list_init.rb",__FILE__)
 require File.expand_path("../../model/price.rb",__FILE__)

puts "load time=#{Time.now-start}"
 class Strategy < Settingslogic
      source File.expand_path('../strategy.yml',__FILE__)
 end

 def init_strategy(strategy)
    #第一步，建立根目录
      $strategy=Strategy.send(strategy)
	   #mk root path
	  $root_path=$strategy.root_path
      Dir.mkdir($root_path)  unless File.exists?($root_path)
 end

 def init_price_database(strategy)
 	price_database_path=File.expand_path(Strategy.send(strategy).price_database,Strategy.send(strategy).root_path)
 	db = SQLite3::Database.new price_database_path

 end

 def init_active_record_price(strategy)

 price_database_path=File.expand_path(Strategy.send(strategy).price_database,Strategy.send(strategy).root_path)

  $price_db=ActiveRecord::Base.establish_connection(
   :adapter   => 'sqlite3',
   :database  => price_database_path
  )

  puts Price.table_exists?
 if Price.table_exists? == false
  ActiveRecord::Migration.class_eval do
    create_table :prices do |t|
    	  t.string :symbol
          t.string :date
          t.string :low
          t.string :high
          t.string :open
          t.string :close
          t.string :volume
          t.timestamps
    end

  end
  else
	puts "table already exists!"	 
end

 end

 def destroy_table(strategy)
 	
 price_database_path=File.join(Strategy.send(strategy).root_path,Strategy.send(strategy).price_database)
  $price_db=ActiveRecord::Base.establish_connection(
   :adapter   => 'sqlite3',
   :database  => price_database_path
  )

  puts Price.table_exists?
 if Price.table_exists? == true
 	#ActiveRecord::Migration.class_eval do
    ActiveRecord::Migration::drop_table(:prices)
 # end
 end
 puts Price.table_exists?
 end

 def batch_insert_record(strategy)
 	price_database_path=File.join(Strategy.send(strategy).root_path,Strategy.send(strategy).price_database)
  $price_db=ActiveRecord::Base.establish_connection(
   :adapter   => 'sqlite3',
   :database  => price_database_path
  )
  start=Time.now
   200000.downto(1001).each do |i|
     Price.create(:symbol=>"adf#{i}",:date=>"2013-12-04",:low=>"3.15",:high=>"4.15",:close=>"7.83",:open=>"1.23",:volume=>"87651234")
    
end
 puts "insert cost time=#{Time.now-start}"

 end

 if $0==__FILE__
 	start=Time.now
 	strategy="hundun_1"
 	init_strategy(strategy)
    init_price_database(strategy)
    #init_active_record_price(strategy)
    #destroy_table(strategy)
    puts "run time=#{Time.now - start}"
     batch_insert_record(strategy)
 end