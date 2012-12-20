class Resource < Webmachine::Resource
  def content_types_provided
    [["plain/text", :to_text]]
  end

  def content_types_accepted
    [["*/*", :accept]]
  end

  def allowed_methods
    %w(GET POST DELETE PUT)
  end

  # POST
  def process_post
    response.body = "POST OK"
  end

  # GET
  def to_text
    response.body = "GET OK"
  end

  # PUT
  def accept
    response.body = "PUT OK"
  end

  # DELETE
  def delete_resource
    response.body = "DELETE OK"
  end

  def finish_request
    response.headers['X-Request-Query'] = request.query
    response.headers['X-Request-Headers'] = request.headers
  end
end
