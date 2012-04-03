class IRWebmachine::Pry::EnterStack < IRWebmachine::Pry::Command
  
  name        'enter-stack'
  group       'irwebmachine'
  description 'Enters the context of a method on the call stack for a webmachine request.'
  banner <<-BANNER
    enter-stack BREAKPOINT

    Enters into the context of a method on the call stack for a webmachine 
    request. BREAKPOINT can be retrieved from the print-stack command.
  BANNER

  def initialize(*)
    super
    @app = target.eval("app")
    @req = @app.last_request
    @hit = false
    @pry = Pry.new :commands => IRWebmachine::Pry::Nav
  end

  def process
    @app.dup.do_request(*@req) do |trace, position|
      if position == index
        @hit = true
      end

      if hit?
        case pry.repl(trace.binding) 
        when nil
          throw(:tracer, :stop)
        when :next
          pry.binding_stack += [trace.binding] 
        when :prev
          # implemented to operate within REPL loop spawned up top.  
        end
      end
    end
  end

private 
 
  def pry
    @pry
  end

  def hit?
    @hit
  end

  def index
    return @index if defined?(@index)   
    position = args.first

    if position.nil?
      @index = 0
    elsif position =~ /^(\d+)$/ 
      @index = position.to_i
    else
      raise Pry::CommandError, "'#{position}' is an invalid stack entry."
    end
  end

end

set = Pry::CommandSet.new
set.commands["enter-stack"] = IRWebmachine::Pry::EnterStack
Pry.commands.import(set)
