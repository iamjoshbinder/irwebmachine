class IRWebmachine::MockApplication
  
  def initialize(app)
    @delegate = app
    @req = nil
    @res = nil
  end

  def delegate
    @delegate
  end

  def last_response
    @res || raise(RuntimeError, "No active request.", []) 
  end

  def last_request
    @req || raise(RuntimeError, "No active request.", [])
  end

  def do_request(*args, &block)
    @req = IRWebmachine::MockRequest.new    
    @res = @req.run(*args)
  end

  %w(get post delete put).each do |type|
    define_method(type) do |*args|
      do_request(type, *args) 
    end
  end
end
