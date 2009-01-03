
require 'test/unit'
require 'shoulda'
require 'mocha' 
require 'active_record'
require 'active_support'

begin
  require 'ruby-debug'
rescue LoadError
  puts "ruby-debug not loaded"
end
 
ROOT = File.join(File.dirname(__FILE__), '..')
RAILS_ROOT = ROOT

$LOAD_PATH << File.join(ROOT, 'lib')
 
require File.join(ROOT, 'lib', 'method_ni.rb')
 
ENV['RAILS_ENV'] ||= 'test'
FIXTURES_PATH = ROOT + "fixtures/"

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
  
def rebuild_class options = {}
  ActiveRecord::Base.send(:include, MethodNi)
  Object.send(:remove_const, "Dummy") rescue nil
  Object.const_set("Dummy", Class.new(ActiveRecord::Base))
  Dummy.class_eval do
    include MethodNi
    has_method_in :costume_method, options
  end
end
 