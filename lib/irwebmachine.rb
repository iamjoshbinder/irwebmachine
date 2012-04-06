module IRWebmachine
 
  require "uri/query_params"
  require "graph"
  require_relative "irwebmachine/mock_application"
  require_relative "irwebmachine/mock_request"
  require_relative "irwebmachine/frame"
  require_relative "irwebmachine/tracer"
  require_relative "irwebmachine/stack"
  require_relative "irwebmachine/version"
  
  def self.app=(app)
    @app = MockApplication.new(app)
  end
    
  def self.app
    @app
  end

end
