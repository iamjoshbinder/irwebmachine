class IRWebmachine::Tracer
  
  def initialize
    @thread   = nil
    @on_event = nil
    @stack   = []
    @targets = []
    @events  = []
  end

  def on_event &block
    @on_event = block
  end

  def add_stack stack
    @stack = stack
  end

  def add_event *event
    @events.push(*event)
  end

  def add_target *target 
    @targets.push(*target)
  end
 
  def finished?
    [false, nil].include? @thread.status
  end

  def continue
    @thread.run
  end

  def stack
    @stack
  end

  def trace
    @thread ||=
    Thread.new do
      Thread.current.set_trace_func tracer
      yield
      Thread.current.set_trace_func(nil) 
    end
  end

 private 

  def tracer
    Proc.new do |event, file, lineno, id, binding, klass|
      has_ancestor = @targets.any? do |t| 
        klass.is_a?(Module) && klass.ancestors.include?(t) 
      end
     
      if has_ancestor && @events.include?(event)
        frame = IRWebmachine::Frame.new(file, lineno, event, binding)
        stack << frame
        @on_event.call(stack) if @on_event 
        Thread.stop
      end
    end
  end
end
