class IRWebmachine::MockApplication
  
  def initialize(app)
    @app = app
    @req = nil
    @res = nil
  end

  def last_response
    @res || raise(RuntimeError, "No active request.", []) 
  end

  def last_request
    @req || raise(RuntimeError, "No active request.", [])
  end

  def do_request(*args, &block)
    tracer = IRWebmachine::Tracer.new
    tracer.add_event "return"
    tracer.add_target Webmachine::Resource::Callbacks
    tracer.on_event(&block) if block

    req = IRWebmachine::MockRequest.new(@app)
    req.add_tracer(tracer)
    @req = req
    @res = req.run(*args)
  end

  %w(get post delete put).each do |type|
    define_method(type) do |*args|
      do_request(type, *args) 
    end
  end
end
