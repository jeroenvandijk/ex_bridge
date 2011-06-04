module Frankie::App
  % An instance of the wrapper object is given to ExBridge when
  % MyApp.run is invoked. The wrapper is initialized with the MyApp object.
  %
  % On each request, the handle_http method is invoked which then tries to
  % find a matching route. If a matching route is found, we call it, otherwise
  % we eventually call the error route with 404 status code. The wrapper is
  % responsible to manage the result given and finally dispatch the response
  % object.
  module Wrapper
    def __bound__(app)
      @('routes: app.routes, 'app: #app())
    end

    def handle_http(request, response)
      verb   = request.request_method
      path   = request.path
      route  = find_route(@routes, verb, path, request)
      result = route.call(@app, request, response)

      if result.__module_name__ == 'String::Behavior
        result = response.body(result)
      end

      result.dispatch!
    end

    private

    def find_route([h|t], verb, path, request)
      result =
        if h.__module_name__ == 'Frankie::App::Route
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
      #Frankie::App::ErrorRoute(404)
    end
  end

  % Main route object that asserts for the verb,
  % route and dispatches the stored method/callback.
  module Route
    attr_reader ['verb, 'path, 'method]

    def __bound__(verb, path, method)
      @('verb: verb, 'path: path, 'method: method)
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
  % TODO Make this receive the request object
  module ErrorRoute
    def __bound__(status)
      @('status, status)
    end

    def match?(_,_)
      true
    end

    def call(_app, _request, response)
      response.set(@status, {}, "Status: #{@status}")
    end
  end

  attr_reader ['routes]

  def __added_as_mixin__(base)
    base.set_ivar('routes, [])
  end

  % Adds a new route to the route set. The route object
  % only needs to respond to a `match?` which receives the
  % request object and to `call` which receives the application
  % (not instanciated yet), request and response objects.
  def bare_route(route_object)
    update_ivar 'routes, _.push(route_object)
  end

  % Add a new route with a verb, path and the callback.
  def route(verb, path, method)
    bare_route(#Frankie::App::Route(verb, path, method))
  end

  def get(route, method)
    route 'GET, route, method
  end

  def post(route, method)
    route 'POST, route, method
  end

  def put(route, method)
    route 'PUT, route, method
  end

  def patch(route, method)
    route 'PATCH, route, method
  end

  def delete(route, method)
    route 'DELETE, route, method
  end

  % Start MyApp using the given *server* and *options*. Valid options are
  % 'port (defaults to 3000) and the process 'name (defaults to
  % Frankie-#{APP_NAME}).
  def run(server, options := {})
    options = options.set_new 'name, "Frankie-#{self.__module_name__}".to_atom
    wrapper = #Frankie::App::Wrapper(self)
    ExBridge.start server, wrapper, options
  end
end