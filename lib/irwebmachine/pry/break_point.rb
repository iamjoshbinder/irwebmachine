class IRWebmachine::BreakPoint
  def initialize(breakpoint)
    @breakpoint = breakpoint
    @hit = false
  end

  def hit?
    @hit
  end

  def match?(*args)
    @hit = true if args.any? { |e| @breakpoint.is_a?(Regexp) ? (e =~ @breakpoint) : (e == @breakpoint) }
    
  end

end
