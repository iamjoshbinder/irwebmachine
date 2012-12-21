class IRWebmachine::Request
  def initialize(app)
    @app = app
    @req = nil
    @res = nil
    @stack = IRWebmachine::Stack.new
  end

  def stack
    @stack
  end

  def run_nonblock(*args)
    setup *args
    @stack.tracer.trace do
      @app.dispatcher.dispatch(@req, @res)
    end
    @res
  end

  def run(*args)
    setup *args
    @stack.tracer.trace { @app.dispatcher.dispatch(@req, @res) }
    while frame = @stack.tracer.continue
      @stack << frame
    end
    @res
  end

  def to_a
    [@req.method, @req.uri.path, @req.query, @req.headers, @req.body]
  end

private
  def setup(type, path, params = {}, headers = {}, body = "")
    uri = URI::HTTP.build(host: "localhost", path: path)
    uri.query_params.merge!(params)
    @req = Webmachine::Request.new(type.upcase, uri, headers, body)
    @res = Webmachine::Response.new
  end
end
