class IRWebmachine::MockRequest

  def initialize(app)
    @app = app
    @req = nil
    @res = nil
    @tracer = IRWebmachine::Tracer.new
  end

  def add_tracer(tracer)
    @tracer = tracer
  end

  def stack
    @tracer.stack
  end

  def run(type, path, params = {}, body = "")
    uri = URI::HTTP.build(host: "localhost", path: path)
    uri.query_params.merge!(params) 

    @req = Webmachine::Request.new(type.upcase, uri, {}, body) 
    @res = Webmachine::Response.new
    @tracer.trace! { @app.dispatcher.dispatch(@req, @res) }
    @res
  end

  def to_a
    [@req.method, @req.uri.path, @req.query, @req.body]
  end

end
