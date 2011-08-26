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
      path   = request.path_chars
      route  = find_route(@routes, verb, path, request)
      result = route.call(#(@app)(request, response))

      if result.__module_name__ == 'String::Behavior
        result = response.body(result)
      end

      result.dispatch!
    end

    private

    def find_route([h|t], verb, path, request)
      result =
        if h.respond_to?('match?, 2)
          h.match?(verb, path) % Optimize the most common case.
        else
          h.match?(request)
        end

      if result
        h
      else
        find_route(t, verb, path, request)
      end
    end

    def find_route([], _, _, _)
      #Frankie::Routes::ErrorRoute(404)
    end
  end
  
  % Main route object that asserts for the verb,
  % route and dispatches the stored method/callback.
  module VerbRoute
    attr_reader ['verb, 'path, 'method]

    def __bound__(verb, path, method)
      @('verb: verb, 'path: path.to_char_list, 'method: method)
    end

    def match?(verb, path)
      @verb == verb andalso @path == path
    end

    def call(app, request, response)
      args = case @method.arity
      match 2
        [request, response]
      match 1
        [response]
      else
        []
      end

      @method.apply_to(app, args)
    end
  end

  % Route that handle errors.
  % TODO Make this invoke a hook in the app.
  module ErrorRoute
    def __bound__(status)
      @('status, status)
    end

    def match?(_)
      true
    end

    def call(_app, _request, response)
      response.set(@status, {}, "Status: #{@status}")
    end
  end
end