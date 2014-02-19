==optionparser and example
* http://ruby-china.org/wiki/building-a-command-line-tool-with-optionparser

== sqlite 3
* http://sqlite-ruby.rubyforge.org/sqlite3/faq.html
* 参考里面的初始化数据库部分

gem install sqlite3

db = SQLite3::Database.new "test.db"

== active_record

http://api.rubyonrails.org/files/activerecord/README_rdoc.html
# connect to SQLite3
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'dbfile.sqlite3')

check table exists?
# Ask from the DB connection
ActiveRecord::Base.connection.table_exists?(:xyz)

# Query tables from Schema
ActiveRecord::Schema.tables.include?("xyz")

# Xyz is your model class, check if its table is present
Xyz.table_exists?


My current understanding is no, all modifications data or schema have to be done through a migration. I have a complete rakefile on github which can be used to perform the migrations outside of Rails.

Alternatively if it is just an initialisation script the following could be used.

ActiveRecord::Base.establish_connection(
   :adapter   => 'sqlite3',
   :database  => './lesson1_AR.db'
)

ActiveRecord::Migration.class_eval do
  create_table :posts do |t|
        t.string  :title
        t.text :body
   end

   create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :short_name
   end

   create_table :tags do |t|
      t.string :tags
   end 
end

具体migration api参考

http://api.rubyonrails.org/classes/ActiveRecord/Migration.html

Dir.glob('**/*.{sh,rb,tcl}').each do |fn|
  content = File.read(fn).gsub('xxxx', 'yyyy')
  File.open(fn, 'w') { |f| f << content }
end 