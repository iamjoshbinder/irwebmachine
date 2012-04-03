require_relative "setup"

class Resource < Webmachine::Resource
  def content_types_provided
    [["plain/text", :to_text]]
  end

  def allowed_methods
    %W(GET POST DELETE PUT)
  end

  def process_post
    201    
  end

  def to_text
    200
  end

  def delete_resource
    204
  end
end

class MockApplicationTest < Test::Unit::TestCase

  def setup
    @app = IRWebmachine::MockApplication.new(app) 
  end

  def test_get
    res = @app.get "/mock_application"
    assert_equal 200 , res.code
  end

  def test_post
    res = @app.post "/mock_application"
    assert_equal 201, res.code
  end

  def test_delete
    res = @app.delete "/mock_application"
    assert_equal 204, res.code
  end

private

  def app
    Webmachine::Application.new do |app|
      app.routes do
        add ["mock_application"], Resource
      end
    end
  end

end
