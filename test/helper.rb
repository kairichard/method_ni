require 'rubygems'
require 'test/unit'
require 'ruby-debug' 
require 'shoulda'

# gem install redgreen for colored test output
begin require 'redgreen'; rescue LoadError; end

require File.expand_path(File.dirname(__FILE__) + '/boot') unless defined?(ActiveRecord)
 