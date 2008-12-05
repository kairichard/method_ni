module MethodNi #:nodoc:

  def self.included(base)
    base.extend ClassMethods
    class << base
      attr_accessor :options
      attr_accessor :attributes
      attr_accessor :hook      
    end
  end

  module ClassMethods
    def has_method_in(attr_names = {},options = {})
      self.attributes   = Array(attr_names)
      self.options      = options.stringify_keys!
      include MethodNi::InstanceMethods
      extend MethodNi::SingletonMethods
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
          instance_eval(send(attribute))
          @methods_applied = public_methods - methods_before
        end        
      end      
      return 
    end
    def applied_methods
      @methods_applied || []
    end
  end
end