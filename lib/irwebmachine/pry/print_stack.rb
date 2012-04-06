class IRWebmachine::Pry::PrintStack < IRWebmachine::Pry::Command
  
  name        'print-stack'
  description 'Prints the call stack for the previous webmachine request.'
  group       'irwebmachine'
  banner <<-BANNER
    print-stack [OPTIONS]
    
    Prints the stack of method calls(in order) made during the previous 
    webmachine request. Classes & Modules unrelated to webmachine are excluded. 
    Optionally accepts a -f switch for filtering the stack.
  BANNER

  def setup
    @app    = target.eval("app")
    @stack  = @app.last_request.stack
    @filter = nil
  end

  def options(opt)
    opt.on :f, 'Filter the stack with a regular expression.', optional: true
  end
  
  def process
    stack = @stack.select { |frame| frame.event?(:call) && frame.to_s =~ filter }
    stack.map!.with_index { |frame, i| "#{i}: #{colorize_code(frame.to_s)}" } 
    stagger_output stack.join("\n") 
  end

private

  def filter
    @filter ||= Regexp.new(opts[:f].to_s)
  end

end

set = Pry::CommandSet.new
set.commands["print-stack"] = IRWebmachine::Pry::PrintStack 
Pry.commands.import(set)
