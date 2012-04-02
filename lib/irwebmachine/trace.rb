class IRWebmachine::Trace

  attr_reader :klass, :method, :binding, :file, :lineno

  def initialize(file, lineno, binding)
    @file    = file
    @lineno  = lineno
    @binding = binding
    @method  = binding.eval("__method__")
    @klass   = binding.eval("self").method(@method).owner 
  end

  def to_s
    "#{@klass}##{@method}"
  end

end
