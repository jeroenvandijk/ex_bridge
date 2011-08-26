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
      {route, params} = find_route(@routes, verb, path, request)
      result = 
        if route.respond_to?('call, 3)
          route.call(#(@app)(request, response, params), request, response)
        else
          route.call(#(@app)(request, response, params))
        end


      if result.__module_name__ == 'String::Behavior
        result = response.body(result)
      end

      result.dispatch!
    end

    private

    def find_route([h|t], verb, path, request)
      result =
        if h.respond_to?('match_route, 2)
          h.match_route(verb, path) % Optimize the most common case.
        else
          h.match_route(request)
        end

      if result
        {h, result}
      else
        find_route(t, verb, path, request)
      end
    end

    def find_route([], _, _, _)
      {#Frankie::Routes::ErrorRoute(404), {}}
    end
  end
  
  % Main route object that asserts for the verb,
  % route and dispatches the stored method/callback.
  module VerbRoute
    attr_reader ['verb, 'path, 'method]

    def __bound__(verb, path, method)
      @('verb: verb, 'path: path.split(~r"/"), 'method: method)
    end

    def match_route(verb, path)
      @verb == verb && match_route(@path, path.to_bin.split(~r"/"), {})
    end

    def match_route([], [], matched)
      matched
    end

    def match_route([<<$', key|binary>> | t1], [value|t2], matched)
      key = key.to_atom
      match_route(t1, t2, matched.set(key, value))
    end
      
    def match_route([h|t1], [h|t2], matched)
      match_route(t1, t2, matched)
    end

    def match_route(_, _, _)
      false
    end

    def call(app)
      @method.apply_to(app, [])
    end
  end

  % Route that handle errors.
  % TODO Make this invoke a hook in the app.
  module ErrorRoute
    def __bound__(status)
      @('status, status)
    end

    def match_route(_)
      {}
    end

    def call(_app, _request, response)
      response.set(@status, {}, "Status: #{@status}")
    end
  end
end

