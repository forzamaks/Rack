require_relative '../timeFormatter'

class FormatTime

  def initialize(app)
    @app = app
  end

  def call(env)
    watch_response(env)
  end

  private

  def watch_response(env)
    request = Rack::Request.new(env)

    path  = request.path
    request_params = request.params['format']

    status, headers, body = @app.call(env)

    if path != '/time'
      formatted_response(404, headers, ["404\n"])
    elsif request_params.nil?
      formatted_response(400, headers, ["invalid_format_name\n"])
    else
      formatter_constructor(request_params, headers)
    end

    
  end

  def formatted_response(status, headers, body)
    response = Rack::Response.new(body, status, headers)
    response.finish
  end

  def formatter_constructor(params, headers)
    formatter = TimeFormatter.new(params)
    if formatter.valid_params?
      body = formatter.time
      status = 200
    else
      invalid_params = formatter.invalid_params
      body = "Unknown time format #{invalid_params}"
      status = 400
    end
    formatted_response(status, headers, ["#{body}\n"])
  end
end