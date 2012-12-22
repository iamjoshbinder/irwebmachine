class IRWebmachine::Frame
  def initialize(binding,event)
    @binding = binding
    @event   = event
    @file    = binding.eval "__FILE__"
    @lineno  = binding.eval "__LINE__"
    @method  = binding.eval "__method__"
    @klass   = binding.eval("self").method(@method).owner
  end

  def event?(type)
    type.to_s == @event
  end

  def to_s
    "#{@klass}##{@method}"
  end
end
