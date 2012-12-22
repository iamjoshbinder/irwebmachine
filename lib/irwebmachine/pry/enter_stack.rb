class IRWebmachine::Pry::EnterStack < Pry::ClassCommand
  match       'enter-stack'
  group       'irwebmachine'
  description 'Enters the context of a method on the call stack for a webmachine request.'
  banner <<-BANNER
    enter-stack BREAKPOINT

    Enters into the context of a method on the call stack for a webmachine
    request. BREAKPOINT can be retrieved from the print-stack command.
  BANNER

  def setup
    @app = target.eval "app"
    @pry = Pry.new :commands => IRWebmachine::Pry::Nav
    @req = IRWebmachine::Request.new @app.unbox
  end

  def process
    @req.dispatch! *@app.last_request
    repl @req.stack.continue
  end
private
  def repl(frame)
    until hit?
      if breakpoint =~ frame.to_s
        @hit = true
      else
        if @req.stack.exhausted?
          raise Pry::CommandError, 'No matching breakpoint.'
        else
          frame = @req.stack.continue
        end
      end
    end
    case @pry.repl(frame.context)
    when nil
      # no-op (exit).
    when :next
      repl @req.stack.next
    when :continue
      repl @req.stack.continue
    when :previous
      repl @req.stack.previous
    end
  end

  def hit?
    @hit
  end

  def breakpoint
    @breakpoint ||= Regexp.new(args.first.to_s)
  end
end

set = Pry::CommandSet.new
set.commands["enter-stack"] = IRWebmachine::Pry::EnterStack
Pry.commands.import(set)
