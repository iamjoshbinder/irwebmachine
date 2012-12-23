module IRWebmachine
  require "uri/query_params"
  require "graph"
  require_relative "irwebmachine/application"
  require_relative "irwebmachine/traced_request"
  require_relative "irwebmachine/frame"
  require_relative "irwebmachine/tracer"
  require_relative "irwebmachine/stack"
  require_relative "irwebmachine/version"

  def self.app=(app)
    @app = Application.new app
  end

  def self.app
    @app
  end
end
