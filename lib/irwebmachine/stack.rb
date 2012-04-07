class IRWebmachine::Stack 
  def initialize(stack = [])
    @stack = stack
    @tracer = IRWebmachine::Tracer.new
    @tracer.add_stack(self) 
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

  def next
    @tracer.continue
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
