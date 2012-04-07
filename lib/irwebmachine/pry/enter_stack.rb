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
    @pry = Pry.new :commands => IRWebmachine::Pry::Nav
  end

  def process
    frame = nil

    @app.dup.do_request(*@req) do |stack|
      frame = stack.next if !frame

      case @pry.repl(frame.binding) 
      when nil
        throw :breakout 
      when :next
        # nothing (yet).
      when :prev
        frame = stack.prev
      when :continue
        frame = stack.next
      end
    end
  end

private 
 
  def repl target

  end

end

set = Pry::CommandSet.new
set.commands["enter-stack"] = IRWebmachine::Pry::EnterStack
Pry.commands.import(set)
