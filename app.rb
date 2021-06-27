class App

  def call(env)
    [status, headers, body]
  end

  private

  def status
    200
  end

  def headers 
    { 'Content-type' => 'text-plain' }
  end

  def body
    ['Welcome aborted!']
  end
  
end