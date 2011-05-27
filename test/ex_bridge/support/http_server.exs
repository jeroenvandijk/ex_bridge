module HTTPServer
  def handle_http(request, response)
    try
      method = request.path[1, -1] + "_loop"
      send method.to_atom, [request, response]
    catch error: kind
      response.serve_body! 500, {}, { error, kind, __stacktrace__ }.inspect
    end
  end

  def dispatch_loop(_request, response)
    response = response.status(200)
    200 = response.status

    response = response.headers.merge "Content-Type": "text/plain"
    { "Content-Type": "text/plain" } = response.headers.to_dict
    "text/plain" = response.headers["Content-Type"]
    another_response = response.headers.clear
    {:} = another_response.headers.to_dict

    response = response.body("Hello world\n")
    "Hello world\n" = response.body
    response.dispatch!
  end

  def dispatch_file_loop(_request, response)
    response = response.file "test_helper.exs"
    "test_helper.exs" = response.file
    response.dispatch!
  end

  def set_loop(_request, response)
    new_response = response.set 200, { "Content-Type": "text/plain" }, "Hello world\n"
    new_response.dispatch!
  end

  def serve_file_loop(_request, response)
    response.serve_file! "test_helper.exs"
  end

  def serve_file_with_headers_loop(_request, response)
    response.serve_file! "test_helper.exs", "Content-Disposition": "attachment; filename=\"cool.ex\""
  end

  def serve_unavailable_file_loop(_request, response)
    response.serve_file! "test_helper.exs.unknown"
  end

  def serve_forbidden_file_loop(_request, response)
    response.serve_file! "../ex_bridge/test_helper.exs"
  end

  def response_cookies_loop(_request, response)
    response = response.cookies.set 'key1, "value1"
    response = response.cookies.set 'key2, "value2", 'domain: "plataformatec.com.br", 'path: "/blog", 'secure: true, 'httponly: false
    response = response.cookies.delete 'key3, 'path: "/blog"
    response.dispatch!
  end

  def request_accessors_loop request, response
    'GET = request.request_method
    "/request_accessors" = request.path
    response.dispatch!
  end

  def request_headers_loop request, response
    ["127.0.0.1", _] = request.headers["Host"].split(~r(:))
    request = request.memoize!('headers)
    "0" = request.headers["Content-Length"]
    "set" = request.headers["Unknown-Header"]
    response.dispatch!
  end

  def request_cookies_loop request, response
    {"key1": "value1", "key2": "value2"} = request.cookies
    response.dispatch!
  end
end