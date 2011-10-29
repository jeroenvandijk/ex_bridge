module Frankie::Routes
  % Wraps the given application in a format that is acceptable for ExBridge.
  %
  % On each request, the handle_http method is invoked which then tries to
  % find a matching route. If a matching route is found, we call it, otherwise
  % we eventually call the error route with 404 status code. The wrapper is
  % responsible to manage the result given and finally dispatch the response
  % object.
  module Wrapper
    def __bound__(app)
      @('routes: app.routes, 'app: app)
    end

    def handle_http(request, response)
      verb   = request.request_method
      path   = request.path_chars.to_bin

      result = @app.handle_http(verb, path, request)
      
      if result.__module_name__ == 'String::Behavior
        result = response.body(result)
      end
      
      result.dispatch!
    end

  end
end

