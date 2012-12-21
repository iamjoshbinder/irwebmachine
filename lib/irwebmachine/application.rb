class IRWebmachine::Application
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
      @req = IRWebmachine::Request.new @app
      @res = @req.run(*[type, *args])
    end
  end
end
