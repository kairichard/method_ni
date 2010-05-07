class Dummy < ActiveRecord::Base
  include MethodNi
  has_method_in :custom_method
end