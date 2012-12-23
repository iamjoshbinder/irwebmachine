class IRWebmachine::TracedRequest
  def initialize(app)
    @app = app
    @req = nil
    @res = nil
    @stack = IRWebmachine::Stack.new
  end

  def stack
    @stack
  end

  def dispatch(*args)
    dispatch!(*args)
    while frame = @stack.tracer.continue
      @stack << frame
    end
    @res
  end

  def dispatch!(type, path, params = {}, headers = {}, body = "")
    uri = URI::HTTP.build(host: "localhost", path: path)
    uri.query_params.merge!(params)
    @req = Webmachine::Request.new type.upcase, uri, headers, body
    @res = Webmachine::Response.new
    @stack.tracer.trace do
      @app.dispatcher.dispatch(@req, @res)
    end
    @res
  end

  def to_a
    [@req.method, @req.uri.path, @req.query, @req.headers, @req.body]
  end
end
