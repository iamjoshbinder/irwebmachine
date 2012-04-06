class IRWebmachine::Stack 
  include Enumerable

  def initialize(stack = [])
    @stack = stack
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

  def each(&block)
    if block_given?
      @stack.each(&block)
      self
    else
      enum_for(:each)
    end
  end

  def to_graph
    graph = Graph.new
    each { |frame| graph.edge(frame.to_s) if frame.event?(:call) }
    graph
  end
end
