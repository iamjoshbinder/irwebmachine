module IRWebmachine
  
  require_relative "irwebmachine/mock_application"
  require_relative "irwebmachine/mock_request"
  require_relative "irwebmachine/trace"
  require_relative "irwebmachine/tracer"
  require_relative "irwebmachine/version"
  
  def self.app=(app)
    @app = MockApplication.new(app)
  end
    
  def self.app
    @app
  end

end
