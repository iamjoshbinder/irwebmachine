class IRWebmachine::Application
  def initialize(app)
    @app = to_app app
    @req = nil
    @res = nil
  end

  def unbox
    @app
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
      @res = @req.dispatch(*[type, *args])
    end
  end

private
  def to_app(obj)
    is_module = obj.is_a? Module
    is_resource = is_module && obj.ancestors.include?(Webmachine::Resource)
    if is_resource
      Webmachine::Application.new do |app|
        app.routes do
          add ["*"], obj
        end
      end
    else
      app
    end
  end
end
