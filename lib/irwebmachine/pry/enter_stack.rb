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
    @app.dup.do_request(*@req) do |frame, position|
      if frame.to_s =~ breakpoint 
        @hit = true
      end

      if hit?
        case pry.repl(frame.binding) 
        when nil
          throw(:tracer, :stop)
        when :next
          throw(:tracer, :next) 
        when :prev
          throw(:tracer, :prev)
        when :continue
          throw(:tracer, :continue) 
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

  def breakpoint
    @breakpoint ||= Regexp.new(args.first)
  end

end

set = Pry::CommandSet.new
set.commands["enter-stack"] = IRWebmachine::Pry::EnterStack
Pry.commands.import(set)
