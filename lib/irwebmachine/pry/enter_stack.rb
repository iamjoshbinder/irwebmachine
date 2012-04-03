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
    @pry = Pry.new :commands => Nav
  end

  def process
    @app.dup.do_request(*@req) do |trace, position|
      if position == index
        @hit = true
      end

      if hit?
        case pry.repl(trace.binding) 
        when nil, :finish
          throw(:tracer, :stop)
        when :next
          pry.binding_stack += [trace.binding] 
        when :prev
          # implemented to operate within the REPL loop we spawn up top.
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
    Integer(args.first) 
  end

end

set = Pry::CommandSet.new
set.commands["enter-stack"] = IRWebmachine::Pry::EnterStack
Pry.commands.import(set)
