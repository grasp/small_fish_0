require File.expand_path("../utility.rb",__FILE__)
require File.expand_path("../../utility/stock_list_init.rb",__FILE__)

require 'fileutils'


def empty_data(strategy)

	root_path=Strategy.send(strategy).root_path
	Dir.new(root_path).each do |symbol_folder|
		sub_folder_path=File.join(root_path,symbol_folder)
		Dir.new(sub_folder_path).each do |sub_folder2|
			unless sub_folder2 =="raw_data" || sub_folder2 =="." || sub_folder2 ==".."
			  second_sub_folder=File.join(sub_folder_path,sub_folder2)
			  # File.delete(second_sub_folder)
			  # FileUtils.rm_rf(second_sub_folder)

			  not work
		   end
		end
	end
end

if $0==__FILE__

	 empty_data("hundun_1")

end