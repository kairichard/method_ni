require 'rubygems'
require 'test/unit'
require 'ruby-debug' 
require 'shoulda'
require 'active_record'

# gem install redgreen for colored test output
begin require 'redgreen'; rescue LoadError; end

require File.expand_path(File.dirname(__FILE__) + '/boot')


require 'factory_girl'


# Let's define a factory for the User model. The class name is guessed from the
# factory name.

Factory.define :with_method do |f|
  f.name 'Method'
  f.custom_method  'def test_method; "hello world" ;end;'
end

Factory.define :without_method do |f|
    f.name 'No Method'
    f.custom_method  'Here I am'
end

