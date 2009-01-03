require File.expand_path(File.dirname(__FILE__) + '/helper')
require File.expand_path(File.dirname(__FILE__) + '/lib/activerecord_test_case')
require File.expand_path(File.dirname(__FILE__) + '/../lib/checksyntax')
class MethodsApplying < ActiveRecordTestCase
  
  fixtures :dummies
    
  context "A Dummy instance/record " do
    setup do 
      @dummy = Dummy.find(1)
    end
    
    should "respond to @instace.applied_methods" do 
      assert @dummy.respond_to? :applied_methods
    end
    
    should "respond to @instace.apply_methods!" do 
      assert @dummy.respond_to? :apply_methods!
      assert_equal @dummy.apply_methods! , nil
    end    
    
    should "respond to @instace.apply_methods" do 
      assert @dummy.respond_to? :apply_methods
      assert_kind_of Dummy , @dummy.apply_methods
    end    
    
  end
  
  context "A Dummy class" do
    
    should "respond to Dummy.find_and_apply_methods" do
      assert Dummy.respond_to? :find_and_apply_methods
    end
    
    should "respond to Dummy.validates_syntax_of" do
      assert Dummy.respond_to? :validates_syntax_of
    end
    
  end
  
    
  context "A Dummy instance/record with one method in #custom_method " do
    setup do 
      @dummy = Dummy.find(1).apply_methods
    end
    
    should "have one applied method" do 
      assert_equal @dummy.applied_methods.count, 1
      assert_equal @dummy.applied_methods , ["test_method"]
    end
    
    should "respond properly to it" do
      assert @dummy.respond_to? @dummy.applied_methods.first
      assert_equal @dummy.send(@dummy.applied_methods.first),"hello world"
      assert_equal @dummy.test_method,"hello world"
    end
  end


  context "A Dummy instance with normal string in #custom_method " do
    setup do 
      @dummy = Dummy.find(2)
    end
    
    should "have no applied method" do 
      assert_equal @dummy.applied_methods.count, 0
      assert_equal @dummy.applied_methods , []
    end
    
    should "raise an error when trying to apply" do
      assert_raise MethodNi::SyntaxErrorInAppliedMethod do
        @dummy.apply_methods
      end
    end
  end
  
  context "A new Dummy instance/record" do
    setup do
      Dummy.class_eval do 
        validates_syntax_of :custom_method , :with => :ruby
      end
      @dummy = Dummy.new :name => "Container"      
    end

    should "be valid if nothing further is happening" do
      assert @dummy.valid?
      assert @dummy.save
    end
    
    should "be valid if correct ruby syntax is inserted into #custom_method" do
      @dummy.custom_method = %{def one;1;end}
      assert @dummy.valid?
      assert @dummy.save      
    end
    
    should "be invalid if incorrect ruby syntax is inserted into #custom_method" do
      syntax = %{def= !o%&%&&wwqae;;;;ne;1;end}
      @dummy.custom_method = syntax
      assert !@dummy.valid?
      assert_not_nil @dummy.errors.on(:custom_method)
      assert_equal @dummy.errors.on(:custom_method), CheckSyntax.new(syntax).error.to_s
      assert !@dummy.save            
    end
  end
  
  
end