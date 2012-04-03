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
    uri = URI.parse(path)
    add_query_params(uri, params) 
    @req = Webmachine::Request.new(type.upcase, uri, {}, body) 
    @res = Webmachine::Response.new
    @tracer.trace! { @app.dispatcher.dispatch(@req, @res) }
    @res
  end

  def to_a
    [@req.method, @req.uri.path, @req.query, @req.body]
  end

private

  # Taken from webmachine-test.
  def add_query_params(uri, params)
    query =
    params.map do |k, v|
      k, v = URI.encode_www_form_component(k), URI.encode_www_form_component(v)
      "#{k}=#{v}"
    end.join('&')

    uri.query = uri.query ? [uri.query, query].join('&') : query
  end


end
