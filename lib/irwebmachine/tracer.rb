require 'thread'

class IRWebmachine::Tracer
  
  def initialize
    @thread  = nil
    @queue   = Queue.new
    @targets = []
    @events  = []
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
    while @queue.empty?
      @thread.run 
      return if finished? 
    end
    @queue.deq
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
      try do
        has_ancestor = @targets.any? do |t| 
          klass.is_a?(Module) && klass.ancestors.include?(t) 
        end
    
        if has_ancestor && @events.include?(event)
          frame = IRWebmachine::Frame.new(file, lineno, event, binding)
          @queue.enq frame
          Thread.stop
        end
      end
    end
  end

  def try
    begin
      yield
    rescue Exception => e
      puts <<-CRASH
        
       ----------------------
        CRASH (IRWebmachine) 
       ----------------------

       Exception #{e.class}
       Reason    #{e.message}

      CRASH

      Thread.current.set_trace_func(nil)
    end
  end
end
