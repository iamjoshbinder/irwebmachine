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

  def initialize(*)
    super
    @app    = target.eval("app")
    @stack  = @app.last_request.stack
    @filter = nil
  end

  def options(opt)
    opt.on :f, 'Filter the stack with a regular expression.', optional: true
  end
  
  def process
    stack = 
    @stack.map.with_index do |trace, index|
      if trace.to_s =~ filter
        "#{text.yellow(index)}: #{colorize_code(trace)}"
      end
    end

    stagger_output stack.compact.join("\n")
  end

  private

  def filter
    @filter ||= Regexp.new(opts[:f].to_s)
  end

end

set = Pry::CommandSet.new
set.commands["print-stack"] = IRWebmachine::Pry::PrintStack 
Pry.commands.import(set) 
