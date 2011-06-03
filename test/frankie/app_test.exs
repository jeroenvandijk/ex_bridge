Code.require_file "../test_helper", __FILE__

module AppTest
  mixin ExUnit::Case

  def basic_string_test
    response = request('get, "/version")
    {_,_,"1.2.3"} = response
  end

  private

  def request(verb, path)
    HTTPClient.request(verb, "http://127.0.0.1:3000#{path}")
  end
end