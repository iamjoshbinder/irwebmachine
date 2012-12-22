require 'thread'
class IRWebmachine::Tracer
  def initialize
    @thread  = nil
    @queue   = SizedQueue.new(1)
    @targets = [BasicObject]
    @events  = ["call", "c-call", "return", "c-return", "class", "end", "line",
    "raise"]
  end

  #
  # The [set\_trace\_func](http://apidock.com/ruby/Kernel/set_trace_func) API
  # documentation has a list of possible events.
  #
  # @param [Array<String>] events
  #   An array of events.
  #
  # @return [void]
  #
  # @example
  #   #
  #   # Push a frame onto the queue when the "call" or "return" event is
  #   # emitted by set_trace_func. By default, all events push a frame
  #   # onto the queue.
  #   #
  #   tracer.events = ["call", "return"]
  #
  def events=(events)
    @events = events
  end

  #
  # @param [Array<Module>] targets
  #   An array of classes/modules.
  #
  # @return [void]
  #
  # @example
  #   #
  #   # Push a frame onto the queue when `binding.eval('self')` has
  #   # Webmachine::Resource::Callbacks somewhere in its ancestry tree.
  #   # By default, targets is equal to [BasicObject].
  #   #
  #   tracer.targets = [Webmachine::Resource::Callbacks]
  #
  def targets=(targets)
    @targets = targets
  end

  #
  # @return [Boolean]
  #   Returns true when the tracer has finished tracing.
  #
  def finished?
    [false, nil].include? @thread.status
  end

  #
  #
  # @return [IRwebmachine::Frame]
  #   Returns an instance of {IRWebmachine::Frame}.
  #
  # @example
  #   #
  #   # Each call to continue resumes & then suspends the tracer.
  #   # If you want to trace until there is no more code to trace you
  #   # could wrap this method in a loop.
  #   #
  #   tracer.continue
  #   tracer.continue
  #
  def continue
    while @queue.empty?
      sleep 0.01
      return if finished?
    end
    @queue.deq
  end

  #
  # @overload def trace(&block)
  #
  #   @param [Proc] block
  #     A block to execute inside the tracer.
  #
  #   @return [void]
  #
  #   @see Tracer#continue
  #
  #   @example
  #     tracer.trace do
  #       …
  #     end
  #
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

       EXCEPTION:
       #{e.class}

       MESSAGE:
       #{e.message}

       BACKTRACE:
       #{e.backtrace.each { |line| puts(line) }}
      CRASH
      Thread.current.set_trace_func(nil)
    end
  end

end
