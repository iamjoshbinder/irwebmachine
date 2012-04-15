class IRWebmachine::Stack 
  def initialize(stack = [])
    @stack = stack
    @index = 0
    @tracer = IRWebmachine::Tracer.new
    @tracer.add_event "call", "return"
    @tracer.add_target Webmachine::Resource::Callbacks
  end
 
  def push(*args)
    @stack.push(*args)
  end
  alias_method :<<, :push

  def pop
    @stack.pop
  end

  def last
    @stack.last
  end

  def tracer
    @tracer
  end

  def previous
    @index -= 1 if @index != 0
    @stack[@index]
  end

  def exhausted?
    @tracer.finished?
  end

  def continue
    if @index < @stack.size - 1
      @index += 1
    else
      @index += 1 if @stack.size != 0 
      @stack << tracer.continue
    end

    @stack[@index]
  end

  def next
    frame = nil

    while frame.nil? || !frame.event?(:call) 
      frame = continue
    end

    frame
  end

  def to_a
    @stack.dup
  end

  def to_graph
    graph = Graph.new
    @stack.each { |frame| graph.edge(frame.to_s) if frame.event?(:call) }
    graph
  end
end
