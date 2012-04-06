class IRWebmachine::Frame

  attr_reader :klass, :method, :binding, :file, :lineno

  def initialize(file, lineno, event,binding)
    @file    = file
    @lineno  = lineno
    @binding = binding
    @method  = binding.eval("__method__")
    @klass = binding.eval("self").method(@method).owner 
    @event = event
  end

  def event?(type)
    type.to_s == @event
  end

  def to_s
    "#{@klass}##{@method}"
  end

end
