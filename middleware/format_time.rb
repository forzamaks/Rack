class FormatTime

  FORMAT = {'year'=> '%Y', 'month'=> '%m', 'day'=> '%d', 'hour'=> '%H', 'minute'=> '%m', 'second'=> '%S'}

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    path  = request.path
    request_params = request.params['format']

    status, headers, body = @app.call(env)

    if path != '/time'
      return [404, headers, ["404\n"]]
    elsif request_params.nil?
      return [400, headers, ["invalid_format_name\n"]]
    end

    params = request_params.split(',')

    if valid_params?(params)
      body = time(params)
      status = 200
    else
      invalid_params = invalid_params(params)
      body = "Unknown time format #{invalid_params}"
      status = 400
    end

    [status, headers, ["#{body}\n"]]

  end

  private

  def time(params)
    body = params.reduce('') { |body_box, param| body_box << FORMAT[param] }
    body = body.split('').join('-')
    Time.now.strftime(body)
  end

  def invalid_params(params)
    params - FORMAT.keys
  end

  def valid_params?(params)
    invalid_params(params).empty?
  end
end