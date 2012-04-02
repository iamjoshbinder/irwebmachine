module IRWebmachine::IRB::Bundle
  def app
    IRWebmachine.app || raise(RuntimeError, "No app set. Use IRWebmachine.app= to set one.", []) 
  end

  def show_stack(filter = //)
    request = app.last_request 
    request.stack.each_with_index do |trace, int|
      puts "#{int}> #{trace}" if trace.to_s =~ filter
    end
    nil
  end

  def enter_stack(num) 
    request = app.last_request
    trace = request.stack[num]
    puts "==> Entering #{trace.klass}##{trace.method}"
    irb(trace.binding)
  end
end
