plugin_root = File.join(File.dirname(__FILE__), '..')
ENV["RAILS_ENV"] = "test"

$LOAD_PATH << File.join(plugin_root, 'lib')
 
require File.join(plugin_root, 'lib', 'method_ni.rb')
