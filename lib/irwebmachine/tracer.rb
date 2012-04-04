class IRWebmachine::Tracer

  attr_reader :stack

  def initialize
    @targets = []
    @events  = []
    @stack   = []
    @on_event = nil
  end

  def trace!
    set_trace_func(tracer) 
    yield
    set_trace_func(nil)
  end

  def on_event(&block) 
    @on_event = block
  end

  def add_target(*args) 
    @targets.concat(args)
  end

  def add_event(*args)
    @events.concat(args)
  end

private

  def tracer
    @tracer ||= lambda do |event, file, lineno, _, binding, receiver|
      has_ancestor = @targets.any? do |t| 
        receiver.is_a?(Module) && receiver.ancestors.include?(t) 
      end

      if has_ancestor && @events.include?(event)
        stack << IRWebmachine::Trace.new(file, lineno, binding)
        action = catch(:tracer) { @on_event.call(stack.last, stack.size-1) if @on_event }
        set_trace_func(nil) if action == :stop
      end
    end
  end

end
