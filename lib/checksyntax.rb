class CheckSyntax
  attr_accessor :error
  attr_accessor :valid
  
  def initialize code
    check_syntax code
  end
  
  def valid?
    @valid
  end
  
  def check_syntax command
    begin 
      catch(:good) { eval("throw :good; #{command}") }; 
      @valid = true 
    rescue SyntaxError => e
      @error = e
      @valid = false 
    end
  end
  
end

