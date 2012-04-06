class IRWebmachine::Tracer

  attr_reader :stack

  def initialize
    @targets  = []
    @events   = []
    @on_event = nil
    @stack = IRWebmachine::Stack.new 
  end

  def trace!
    set_trace_func method(:tracer).to_proc
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

  def tracer(event, file, lineno, id, binding, receiver) 
    begin
      has_ancestor = @targets.any? do |t| 
        receiver.is_a?(Module) && receiver.ancestors.include?(t) 
      end

      if has_ancestor && @events.include?(event)
        stack << IRWebmachine::Frame.new(file, lineno, event, binding)
        action = catch(:tracer) { @on_event.call(stack.last) if @on_event }
        set_trace_func(nil) if action == :stop
      end
    rescue Exception => e
      print_error(e)
      set_trace_func(nil)
    end
  end

  def print_error(e)
    puts <<-CRASH

      -- CRASH (IRWebmachine) -- 
      
      Exception => #{e.class}
      Reason    => #{e.message}
      Backtrace => #{e.backtrace.join "\n"}
    
    CRASH
  end
end
