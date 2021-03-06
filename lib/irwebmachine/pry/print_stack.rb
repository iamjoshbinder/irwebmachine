class IRWebmachine::Pry::PrintStack < Pry::ClassCommand

  match       'print-stack'
  description 'Prints the call stack for the previous webmachine request.'
  group       'irwebmachine'
  banner <<-BANNER
    print-stack [OPTIONS]

    Prints the stack of method calls(in order) made during the previous
    webmachine request. The stack excludes calls that don't originate from
    a subclass of Webmachine::Resource.
  BANNER

  def setup
    @app = target.eval "app"
  end

  def options(opt)
    opt.on :f, 'Filter the stack with a regular expression.', optional: true
  end

  def process
    frames = stack.to_a.map do |frame|
      if frame.ruby_call? && frame.to_s =~ filter
        frame.to_s
      end
    end.compact.join "\n"
    stagger_output text.with_line_numbers(frames, 0)
  end

private
  def stack
    @app.last_request.stack
  end

  def filter
    Regexp.new(opts[:f].to_s)
  end
end
set = Pry::CommandSet.new
set.commands["print-stack"] = IRWebmachine::Pry::PrintStack
Pry.commands.import(set)
