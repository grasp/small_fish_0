require File.expand_path("../../utility/utility.rb",__FILE__)
require "json"


def get_signal_schema
	schema_file=File.expand_path("../signal_schema_1.txt",__FILE__)
	$schema= JSON.parse(File.read(schema_file))
	return $schema
end

if $0==__FILE__
	get_signal_schema
end