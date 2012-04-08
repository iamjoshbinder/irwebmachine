class IRWebmachine::MockRequest

  def initialize
    @app = IRWebmachine.app.delegate
    @req = nil
    @res = nil
    @stack = IRWebmachine::Stack.new
  end

  def stack
    @stack
  end

  def run_nonblock *rest
    setup *rest
    @stack.tracer.trace { @app.dispatcher.dispatch(@req, @res) }
    @res
  end

  def run *rest
    setup *rest 
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

  def setup type, path, params = {}, headers = {}, body = ""
    uri = URI::HTTP.build(host: "localhost", path: path)
    uri.query_params.merge!(params) 
    @req = Webmachine::Request.new(type.upcase, uri, headers, body)
    @res = Webmachine::Response.new
  end

end
