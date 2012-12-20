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

  %w(get post delete put).each do |type|
    define_method(type) do |*args|
      do_request(type, *args)
    end
  end
private
  def do_request(*args, &block)
    @req = IRWebmachine::MockRequest.new @app
    @res = @req.run(*args)
  end
end
