require 'thread'

class IRWebmachine::Tracer

  def initialize
    @thread  = nil
    @queue   = SizedQueue.new(1)
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
      sleep(0.01)
      return if finished?
    end
    @queue.deq
  end

  def trace
    @thread ||=
    Thread.new do
      Thread.current.set_trace_func method(:tracer).to_proc
      yield
      Thread.current.set_trace_func(nil)
    end
  end

private

  def tracer(event, file, lineno, id, binding, klass)
    try do
      has_ancestor = @targets.any? do |t|
        # This says, "binding.eval('self') references a class or module,
        # and the event(f. ex ':call') came from one of the iterated
        # targets".
        klass.is_a?(Module) && klass.ancestors.include?(t)
      end
      if has_ancestor && @events.include?(event)
        frame = IRWebmachine::Frame.new(binding,event)
        @queue.enq(frame)
      end
    end
  end

  def try
    begin
      yield
    rescue SystemStackError => e
      puts <<-CRASH

       ----------------------
        CRASH (IRWebmachine)
       ----------------------

       The tracer appears to be locked in infinite
       recursion. This may be a bug in IRWebmachine,
       but your own code may be the cause.

       The tracer will stop execution now, but the
       stack up to the point of infinite recursion
       is retained for debugging.

      CRASH
      Thread.current.set_trace_func(nil)
    rescue Exception => e
      puts <<-CRASH

       ----------------------
        CRASH (IRWebmachine)
       ----------------------

       The tracer has crashed.
       This is a bug in IRWebmachine.
       Please report to https://github.com/generalassembly/irwebmachine.
       Thanks!

       Error (#{e.class})
       #{e.message}

      CRASH
      Thread.current.set_trace_func(nil)
    end
  end

end
