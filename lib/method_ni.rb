require File.expand_path(File.dirname(__FILE__) + '/checksyntax')
module MethodNi #:nodoc:
  
  class SyntaxErrorInAppliedMethod < StandardError
    def initialize text
        super text
    end
  end
  
  def self.included(base)
    base.extend ClassMethods
    class << base
      attr_accessor :options,:attributes
    end
  end

  module ClassMethods
    def has_method_in(attr_names = {},options = {})
      self.attributes   = Array(attr_names)
      self.options      = options.stringify_keys!
      include MethodNi::InstanceMethods
      extend MethodNi::SingletonMethods      
    end    
    
    def validates_syntax_of(*args)
      options = args.extract_options!.symbolize_keys
      attrs   = args.flatten
      
      validates_each attrs,options do |record, attr_name, value|
        syntax = CheckSyntax.new %{#{value}}
        if !syntax.valid?
          record.errors.add(attr_name,syntax.error.to_s)
        end
      end       
    end
    
  end
  
  module SingletonMethods    
    def find_and_apply_methods(*args)
      records = self.find(*args)      
      if records.kind_of?(Array)
        records.each(&:apply_methods!)
      else
        records.apply_methods!      
      end      
      records
    end
  end
  
  module InstanceMethods
    def apply_methods!
      self.class.attributes.each do |attribute|                
        if not send(attribute).nil?          
          methods_before = public_methods
          instance_eval(send(attribute)) rescue raise SyntaxErrorInAppliedMethod.new "Could not apply method from #{attribute}"
          @methods_applied = public_methods - methods_before
        end        
      end      
      return 
    end
    
    def apply_methods
      self.apply_methods!
      return self 
    end
    
    
    def applied_methods
      @methods_applied || []
    end
  end
end