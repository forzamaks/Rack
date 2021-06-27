require 'rack'

app = Proc.new do |env|
  [
    200,
    { 'Content-type' => 'text/plain' },
    ['Welocme aborted!\n']
  ]

end

Rack::Handler::WEBtick.run app