% Handles all tests for the request/response bridge. The server_options returns a
% function that dispatches an internal loop method based on the request path.
module ServerCase
  def dispatch_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/dispatch")
    { 200, headers, "Hello world\n" } = response
    ["text/plain"] = headers["Content-Type"]
  end

  def dispatch_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/dispatch_file")
    { 200, _headers, body } = response
    self.assert_include "% ASSERTION FLAG", body
  end

  def set_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/set")
    { 200, headers, "Hello world\n" } = response
    ["text/plain"] = headers["Content-Type"]
  end

  def serve_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_file")
    { 200, _headers, body } = response
    self.assert_include "% ASSERTION FLAG", body
  end

  def serve_file_with_headers_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_file_with_headers")
    { 200, headers, _body } = response
    ["attachment; filename=\"cool.ex\""] = headers["Content-Disposition"]
  end

  def serve_forbidden_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_forbidden_file")
    { 403, _headers, _body } = response
  end

  def serve_unavailable_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_unavailable_file")
    { 404, _headers, _body } = response
  end

  def response_cookies_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/response_cookies")
    { 200, headers, "" } = response
    cookies = headers["Set-Cookie"]
    3 = cookies.size
    "key1=value1; httponly" = cookies[0]
    "key2=value2; path=/blog; domain=plataformatec.com.br; secure" = cookies[1]
    "key3=deleted; expires=1970-01-01 00:00:01; path=/blog; httponly" = cookies[2]
  end

  def request_accessors_test
    { 200, _headers, _body } = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/request_accessors")
  end

  def request_headers_test
    { 200, _headers, _body } = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/request_headers", "unknown-header": "set")
  end

  def request_cookies_test
    { 200, _headers, _body } = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/request_cookies", "Cookie": "key1=value1; key2=value2")
  end
end